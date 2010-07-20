#!/usr/bin/ruby
# -*- coding: utf-8 -*-

$: << File.dirname(File.expand_path($PROGRAM_NAME)) + "/../lib/"

require 'test/unit'
require 'waveforce'
require 'waveforce/notify'

class NotifyTest < Test::Unit::TestCase
  def setup
    WaveForce.class_eval{remove_const(:NOTIFY_TIMEOUT)}
    WaveForce.const_set(:NOTIFY_TIMEOUT, 3)
    @params = {
      :title => "test title",
      :text  => "test channel - test_program",
      :host  => "localhost", # テスト時にIPアドレスを指定すること
      :passwd => "paranoia" # テスト時にパスワードを設定すること
    }
  end

  #============ 正常系テスト ============#
  # 正常に通知できること
  def test_ok_notify
    assert(WaveForce.notify(@params))
  end

  #============ 異常系テスト ============#
  # パスワードが間違っていて正常に通知できないこと
  def test_ng_notify_invalid_password
    @params[:passwd] = "xxxxxxx"

    # privateメソッドにアクセスするために拡張する
    WaveForce.class_eval do
      def self.test_method_for_private(e)
        gntp_notify(e)
      end
    end

    WaveForce.config = @params
    assert_equal(WaveForce.test_method_for_private(@params), false)
  end

  # Growlが起動していないこと(タイムアウトが発生すること)
  def test_ng_notify_not_growl_start
    # 定数を削除
    WaveForce.class_eval{remove_const(:NOTIFY_TIMEOUT)}
    WaveForce.const_set(:NOTIFY_TIMEOUT, 0.00000001)

    # privateメソッドにアクセスするために拡張する
    WaveForce.class_eval do
      def self.test_method_for_private(e)
        gntp_notify(e)
      end
    end

    assert_equal(WaveForce.test_method_for_private(@params), false)
  end
end