#!/usr/bin/env ruby 
# -*- encoding: utf-8 -*-
require "rubygems"
require "selenium-webdriver"
require "test/unit"

class Test_mobile < Test::Unit::TestCase

  def setup
    @driver = Selenium::WebDriver.for :firefox
    @base_url = "http://oasis.mogya.com/mobile/"
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  def teardown
    @driver.quit
    assert_equal [], @verification_errors
  end
  
  # 普通に検索して結果ページが出ることのテスト 
  def test_search
    @driver.get(@base_url)
    @driver.find_element(:id, "input_station").clear
    @driver.find_element(:id, "input_station").send_keys "いわき駅"
    @driver.find_element(:css, "#searchform input[type=\"submit\"]").click
    assert element_present?(:css, "#searchform input[value=\"いわき駅(JR常磐線)\"]")
    @driver.find_element(:css, "#searchform input[type=\"submit\"]").click
    assert_match(/^[\s\S]*いわき駅[\s\S]*$/, @driver.title)
  end
  # 結果が出せないときエラーページを表示
  def test_notfound
    @driver.get(@base_url)
    @driver.find_element(:id, "input_station").clear
    @driver.find_element(:id, "input_station").send_keys "そんな名前の駅などないのに"
    @driver.find_element(:css, "#searchform input[type=\"submit\"]").click
    # ERROR: Caught exception [ERROR: Unsupported command [isTextPresent]]
  end
  # 同じ名前の駅があるとき「もしかして」を出す → 携帯サイトでは駅一覧が出るのでこの機能は存在しない
  
  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def verify(&blk)
    yield
  rescue Test::Unit::AssertionFailedError => ex
    @verification_errors << ex
  end
end
