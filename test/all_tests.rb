#!/usr/bin/ruby
require 'test/unit/testsuite'
require 'notify_test'
require 'util_test'
#require 'log_test'
require 'crawler_test'
require 'store_test'

class AllTests
  def self.suite
    suite = Test::Unit::TestSuite.new( "all tests." )
    suite << NotifyTest.suite
    suite << UtilTest.suite
    #sutie << LogTest.suite
    suite << CrawlerTest.suite
    suite << StoreTest.suite
    return suite
  end
end
