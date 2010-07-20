require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'timeout'

module WaveForce
  class Crawler
    URL = 'http://www.tv2ch.info/'
    TIMEOUT = 10

    # 必ずタイムアウト処理を呼び出し元で行うこと。
    # 呼び出し元でthrowされた例外をログに出力する(疎な依存関係にするため)。
    def exec
      channels = []
      html = timeout(TIMEOUT) do Hpricot(open(URL).read) end
      html = html.search("//div").inner_html.
        gsub(/&nbsp;|\n|\.|　/, '').split(/<br \/>/)
      html.each do |e|
        channel_data = e.split("│")
        next unless /^[1-7]{1}/ =~ e && channel_data.length == 5
        channels << {
          :channel => channel_data[1],
          :program => channel_data[4],
          :response => ($1 if /(^\d*)/ =~ channel_data[2])
        }
      end
      channels
    end
  end
end