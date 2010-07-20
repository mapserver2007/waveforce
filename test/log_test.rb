#!/usr/bin/ruby
# -*- coding: utf-8 -*-

$: << File.dirname(File.expand_path($PROGRAM_NAME)) + "/../lib/"

require 'test/unit'
require 'waveforce/log'

class LogTest < Test::Unit::TestCase
  # 各テストメソッドが呼ばれる前に呼ばれるメソッド
  def setup
  end

  # 各テストメソッドが呼ばれた後に呼ばれるメソッド
  def teardown
  end

  #============ 正常系テスト ============#

  #============ 異常系テスト ============#

end