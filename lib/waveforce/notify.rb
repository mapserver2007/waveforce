require 'rubygems'
require 'ruby_gntp'
require 'waveforce/log'
require 'waveforce/crawler'
require 'waveforce/store'
require 'waveforce/util'
require 'pathname'
require 'timeout'

module WaveForce
  class << self
    def config=(params)
      if params[:config]
        @params = WaveForce::Util.load(params[:config])
      else
        @params = params
      end
      @log = WaveForce::Log.new(params[:log], 1)
      @params[:app_name] = APP_NAME
    end

    def notify(params)
      result = false
      begin
        self.config = params
        crawler = WaveForce::Crawler.new
        check_gap(crawler.exec)
        result = true
      rescue TimeoutError => e
        @log.error(e.message)
      rescue Errno::ENOENT => e
        $stderr.puts "[ERROR]\t#{e.message}"
        @log.error(e.message)
      end
      result
    end

    private

    def gntp_notify(params)
      result = false
      begin
        timeout(NOTIFY_TIMEOUT) do
          GNTP.notify(params)
          channel, program = params[:text].split(/\s-\s/)
          @log.info("channel：" + channel)
          @log.info("program：" + program)
        end
        result = true
      # ホスト、パスワード、アイコンパスのいずれかが間違っている場合
      rescue RuntimeError => e
        $stderr.puts "Invalid host or password or icon."
        @log.error("Invalid host or password or icon.")
      # ローカルマシンでGrowlが起動していない場合
      rescue Timeout::Error
        $stderr.puts "Growl does not started."
        @log.error("Growl does not started.")
      # その他のエラー
      rescue => e
        $stderr.puts e.message
        @log.fatal(e.message)
      end
      result
    end

    def save_data(data)
      begin
        raise "#{mapper(data[:channel])}.db save is failure" if @params[:db].nil?
        dbpath = Pathname.new(
          @params[:db] + "/#{mapper(data[:channel])}.db"
        ).cleanpath.to_s
        db = WaveForce::Store.new(dbpath)
        data.each do |k, v| db.save(k.to_s, v) end
      rescue => e
        $stderr.puts "[ERROR]\t#{e.message}"
        @log.error(e.message)
      end
    end

    def read_data(channel, key)
      begin
        raise "#{channel}.db read is failure" if @params[:db].nil?
        dbpath = Pathname.new(
          (@params[:db] ||= "") + "/#{channel}.db"
        ).cleanpath.to_s
        db = WaveForce::Store.new(dbpath)
        db.get(key)
      rescue => e
        $stderr.puts "[ERROR]\t#{e.message}"
        @log.error(e.message)
      end
    end

    def check_gap(current)
      current.each do |e|
        res1 = read_data(mapper(e[:channel]), 'response')
        res2 = e[:response]
        # 今回取得の勢いが閾値を超えている場合
        @params[:response_border] ||= DEFAULT_RESPONSE_BORDER
        if !res1.nil? && res2.to_i > @params[:response_border]
          ratio = ((res2.to_f / res1.to_i - 1) * 100).round rescue 0
          case ratio
          # 前回比較で勢いの伸びが100%～199%の場合
          when 100 .. 199
            @params[:title] = "LEVEL:#{LEVEL_WARNING}\n#{res2}レス/分 加速率:#{ratio}%"
            @params[:text] = "#{e[:channel]} - #{e[:program]}"
            gntp_notify(@params)
          # 前回比較で勢いの伸びが200%～299%の場合
          when 200 .. 299
            @params[:title] = "LEVEL:#{LEVEL_IMPORTANT}\n#{res2}レス/分 加速率:#{ratio}%"
            @params[:text] = "#{e[:channel]} - #{e[:program]}"
            gntp_notify(@params)
          # 前回比較で勢いの伸びが300%超の場合
          when 300 .. (1.0 / 0)
            @params[:title] = "LEVEL:#{LEVEL_EMERGENCY}\n#{res2}レス/分 加速率:#{ratio}%"
            @params[:text] = "#{e[:channel]} - #{e[:program]}"
            gntp_notify(@params)
          end
        end
        save_data(e)
      end
    end
  end
end