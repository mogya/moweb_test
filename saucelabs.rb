# -*- encoding: utf-8 -*-
require "rubygems"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"

module HtmlTestSuppeter
  def element_present?(how, what)
    @browser.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
end

class SaucelabsTestCase < Test::Unit::TestCase
  include HtmlTestSuppeter
  def initialize *args
    @remote_driver_url = "http://mogya:0fab1600-e18f-4a1d-9994-bb6bea67e165@ondemand.saucelabs.com:80/wd/hub".freeze
    @base_url = "http://oasis.mogya.com/".freeze
    super
  end

  def setup
    create_browser unless @browser
  end

  def teardown
    @browser.quit if (@browser)
  end
end

class SaucelabsTestCasePC < SaucelabsTestCase
  def create_browser
    browser_env = ENV["BROWSER"]
    cap = nil
    case browser_env
    when "win_ie6"
      cap = Selenium::WebDriver::Remote::Capabilities.internet_explorer
      cap.platform = 'Windows XP'
      cap.version = '6'
      cap[:name] = "WindowsXP IE6"
    when "win_ie7", nil
      cap = Selenium::WebDriver::Remote::Capabilities.internet_explorer
      cap.platform = 'Windows XP'
      cap.version = '7'
      cap[:name] = "WindowsXP IE7"
    when "win_ie_latest"
      cap = Selenium::WebDriver::Remote::Capabilities.internet_explorer
      cap.platform = 'Windows 8.1'
      cap.version = '11'
      cap[:name] = "Windows8.1 IE11"
    when /\Awin_ff/
      cap = Selenium::WebDriver::Remote::Capabilities.firefox
      cap.platform = 'Windows 8.1'
      cap.version = '26'
      cap[:name] = "Windows8.1 firefox26"
    when /\Awin_chrome/
      cap = Selenium::WebDriver::Remote::Capabilities.chrome
      cap.platform = 'Windows 8.1'
      cap.version = '31'
      cap[:name] = "Windows8.1 Chrome31"
    when /\Amac_chrome/
      cap = Selenium::WebDriver::Remote::Capabilities.chrome
      cap.platform = 'OS X 10.9'
      cap.version = '31'
      cap[:name] = "Mac OSX10.9 Chrome31"
    when /\Amac_safari/
      cap = Selenium::WebDriver::Remote::Capabilities.safari
      cap.platform = 'OS X 10.9'
      cap.version = '7'
      cap[:name] = "Mac OSX10.9 Safari7"
    end
    raise "invalid browser: <#{browser_env.inspect}>" unless (cap)
    @browser_name = cap[:name]
    @browser = Selenium::WebDriver.for(
      :remote,
      :url => @remote_driver_url,
      :desired_capabilities => cap)
  end
end
