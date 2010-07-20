#!/usr/bin/ruby
# -*- coding: utf-8 -*-

$: << File.dirname(File.expand_path($PROGRAM_NAME)) + "/../lib/"

require 'test/unit'
require 'date'
require 'fileutils'
require 'waveforce/store'

class StoreTest < Test::Unit::TestCase
  # 各テストメソッドが呼ばれる前に呼ばれるメソッド
  def setup
    # テスト用ディレクトリ作成
    @temp_dir = "C:/" + DateTime.now.strftime("%Y%m%d%H%M%S")
    @temp_notfound_dir = "c:/xxxxxxxx"
    FileUtils.mkdir(@temp_dir)
    # DBファイル名
    @dbfile = "cache.db"
    # 格納するKey-Value
    @key = "testkey"
    @value = "テストデータ"
  end

  # 各テストメソッドが呼ばれた後に呼ばれるメソッド
  def teardown
    # テスト用ディレクトリ削除
    FileUtils.rm_r(@temp_dir)
  end

  #============ 正常系テスト ============#

  # DBに正常にデータを登録できること
  def test_ok_save_data
    db = WaveForce::Store.new(@temp_dir + "/" + @dbfile)
    inserted_data = db.save(@key, @value)
    assert_equal(inserted_data, @value)
  end

  # DBから正常にデータを読み出せること
  def test_ok_read_data
    db = WaveForce::Store.new(@temp_dir + "/" + @dbfile)
    db.save(@key, @value)
    read_data = db.get(@key)
    assert_equal(read_data, @value)
  end

  #============ 異常系テスト ============#

  # ディレクトリが存在しない場合、DBファイルを生成できないこと
  def test_ng_create_dbfile
    begin
      WaveForce::Store.new(@temp_notfound_dir + "/" + @dbfile)
      flunk("never executed processing.")
    rescue PStore::Error => e
      assert_equal(
        "directory #{@temp_notfound_dir} does not exist",
        e.message
      )
    end
  end
end