require 'pathname'
require 'logger'

module WaveForce
  class Log
    def initialize(path, level = nil)
      if !!(FileTest::directory?(path) rescue nil)
        level = [0, 1, 2, 3, 4].index(level) || Logger::DEBUG
        @logger = Logger.new(logfile(path))
        @logger.level = level
      else
        $stderr.puts "[ERROR]\tInvalid log directory path" unless path.nil?
      end
    end

    def fatal(msg)
      @logger.fatal(msg) unless @logger.nil?
    end

    def error(msg)
      @logger.error(msg) unless @logger.nil?
    end

    def warn(msg)
      @logger.warn(msg) unless @logger.nil?
    end

    def info(msg)
      @logger.info(msg) unless @logger.nil?
    end

    def debug(msg)
      @logger.debug(msg) unless @logger.nil?
    end

    def logfile(dir)
      Pathname.new(dir + "/" + "#{Time.now.strftime("%Y%m%d")}.log").cleanpath
    end
  end
end