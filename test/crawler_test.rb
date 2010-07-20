#!/usr/bin/ruby
# -*- coding: utf-8 -*-

$: << File.dirname(File.expand_path($PROGRAM_NAME)) + "/../lib/"

require 'test/unit'
require 'waveforce/crawler'

class CrawlerTest < Test::Unit::TestCase
  # 各テストメソッドが呼ばれる前に呼ばれるメソッド
  def setup
    WaveForce::Crawler.class_eval{remove_const(:TIMEOUT)}
    WaveForce::Crawler.const_set(:TIMEOUT, 10)
  end

  # 各テストメソッドが呼ばれた後に呼ばれるメソッド
  def teardown
  end

  #============ 正常系テスト ============#

  # 地上波実況データを取得できること
  def test_ok_crawler
    @crawler = WaveForce::Crawler.new
    data = @crawler.exec
    assert_not_nil(data)
    assert(data.length != 0)
  end

  #============ 異常系テスト ============#

  # タイムアウトが発生し地上波実況データを取得できないこと
  def test_ng_crawler_timeout
    # 定数を削除
    WaveForce::Crawler.class_eval{remove_const(:TIMEOUT)}
    # 定数を再設定
    WaveForce::Crawler.const_set(:TIMEOUT, 0.00000001)

    @crawler = WaveForce::Crawler.new
    begin
      @crawler.exec
      # 例外が発生しなければテストは失敗する
      flunk("never executed processing.")
    rescue TimeoutError => e
      assert_equal(e.message, "execution expired")
    end
  end
end