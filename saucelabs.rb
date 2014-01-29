#!/usr/bin/env ruby 
# -*- encoding: utf-8 -*-
require "rubygems"
require "selenium-webdriver"
require "test/unit"

class SaucelabsTestCase < Test::Unit::TestCase
  def initialize
    super
    @REMOTE_DRIVER_URL = "http://mogya:0fab1600-e18f-4a1d-9994-bb6bea67e165@ondemand.saucelabs.com:80/wd/hub"
    @drivers = []
  end
  def addCaps(caps)
    @drivers << Selenium::WebDriver.for(
      :remote,
      :url => @REMOTE_DRIVER_URL,
      :desired_capabilities => caps)
  end
  def each_driver
    @drivers.each{|driver|
      @driver = driver
      yield
    }
  end  
  def teardown
  end

  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  unless defined?(Test::Unit::AssertionFailedError)
    Test::Unit::AssertionFailedError = MiniTest::Assertion
  end
  def verify(&blk)
    yield
  rescue Test::Unit::AssertionFailedError => ex
    @verification_errors << ex
  end
end

class PCTestCase < SaucelabsTestCase
  def setup
    @base_url = "http://oasis.mogya.com/"
    win_ie6 = Selenium::WebDriver::Remote::Capabilities.internet_explorer
    win_ie6.platform = 'Windows XP'
    win_ie6.version = '6'
    win_ie6[:name] = "Windows IE6"
    addCaps(win_ie6)

    win_ie_latest = Selenium::WebDriver::Remote::Capabilities.internet_explorer
    win_ie_latest.platform = 'Windows 8.1'
    win_ie_latest.version = '11'
    win_ie_latest[:name] = "Windows IE LATEST"
    addCaps(win_ie6)

    win_ff_latest = Selenium::WebDriver::Remote::Capabilities.firefox
    win_ff_latest.platform = 'Windows 8.1'
    win_ff_latest.version = '26'
    win_ff_latest[:name] = "Windows FireFox LATEST"
    addCaps(win_ff_latest)

    win_chrome = Selenium::WebDriver::Remote::Capabilities.chrome
    win_chrome.platform = 'Windows 7'
    win_chrome.version = '31'
    win_ff_latest[:name] = "Windows Chrome LATEST"
    addCaps(win_chrome)

    mac_safari = Selenium::WebDriver::Remote::Capabilities.safari
    mac_safari.platform = 'OS X 10.9'
    mac_safari.version = '7'
    mac_safari[:name] = "Mac Safari LATEST"
    addCaps(mac_safari)
  end
  def teardown
    assert_equal [], @verification_errors
  end
end
