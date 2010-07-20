#!/usr/bin/ruby
# -*- coding: utf-8 -*-

$: << File.dirname(File.expand_path($PROGRAM_NAME)) + "/../lib/"

require 'test/unit'
require 'date'
require 'fileutils'
require 'waveforce/util'

class UtilTest < Test::Unit::TestCase
  # 各テストメソッドが呼ばれる前に呼ばれるメソッド
  def setup
    # テスト用親ディレクトリ
    @temp_parent_dir = "C:/" + DateTime.now.strftime("%Y%m%d%H%M%S")
    @temp_child_dir  = "waveforce_tmp"
    @temp_notfound_dir = @temp_parent_dir + '/' + DateTime.now.strftime("%Y%m%d%H%M%S")
    # テスト用ディレクトリ作成
    FileUtils.mkdir(@temp_parent_dir)
  end

  # 各テストメソッドが呼ばれた後に呼ばれるメソッド
  def teardown
    # テスト用ディレクトリ削除
    FileUtils.rm_r(@temp_parent_dir)
  end

  #============ 正常系テスト ============#

  # 新規でディレクトリを生成できること(ログを格納するためのディレクトリ)
  def test_ok_create_dir
    # 日付のディレクトリを作成
    t = DateTime.now
    child_dir = t.strftime("%Y%m%d")
    assert(WaveForce::Util.create_dir(@temp_parent_dir, child_dir))
  end

  #============ 異常系テスト ============#

  # ディレクトリが既に存在する場合、新規でディレクトリを生成できないこと
  def test_ng_create_dir
    # 日付のディレクトリを作成
    t = DateTime.now
    child_dir = t.strftime("%Y%m%d")
    WaveForce::Util.create_dir(@temp_parent_dir, child_dir)

    # 同じ場所にディレクトリを作ろうとして失敗する
    assert_nil(WaveForce::Util.create_dir(@temp_parent_dir, child_dir))
  end

  # 親ディレクトリが存在しない場合、その下に新規でディレクトリを生成できないこと
  def test_ng_parent_notfound_create_dir
    # 存在しない場所にディレクトリを作ろうとして失敗する
    t = DateTime.now
    child_dir = t.strftime("%Y%m%d")
    assert_nil(WaveForce::Util.create_dir(@temp_notfound_dir, child_dir))
  end

end