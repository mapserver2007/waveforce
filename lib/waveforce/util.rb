require 'pathname'
require 'logger'

module WaveForce
  module Util
    def self.file?(e)
      !!(FileTest.exist?(e) rescue nil)
    end

    def self.directory?(e)
      !!(FileTest::directory?(e) rescue nil)
    end

    def self.create_dir(parent, child)
      # 親ディレクトリが存在しない場合
      return nil unless directory?(parent)

      path = Pathname.new(parent + "/" + child)
      pathname = path.cleanpath

      # すでにディレクトリがある場合
      return nil if directory?(pathname)

      # ディレクトリの生成
      begin
        Dir::mkdir(pathname)
        pathname.cleanpath
      rescue => e
        puts e.message
        nil
      end
    end

    def self.load(path)
      config = YAML.load_file(path)
      config.inject({}){|r, entry| r[entry[0].to_sym] = entry[1]; r}
    end
  end
end