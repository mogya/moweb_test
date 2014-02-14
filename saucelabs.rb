# -*- encoding: utf-8 -*-
require 'bundler/setup'
require "rubygems"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require 'ci/reporter/rake/test_unit_loader'

ENV['TEST_ENV_NUMBER'] ||= '4'

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
    caps = nil
    case browser_env
    when "win_ie6"
      caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer
      caps.platform = 'Windows XP'
      caps.version = '6'
      caps[:name] = "WindowsXP IE6"
    when "win_ie7", nil
      caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer
      caps.platform = 'Windows XP'
      caps.version = '7'
      caps[:name] = "WindowsXP IE7"
    when "win_ie_latest"
      caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer
      caps.platform = 'Windows 8.1'
      caps.version = '11'
      caps[:name] = "Windows8.1 IE11"
    when /\Awin_ff/
      caps = Selenium::WebDriver::Remote::Capabilities.firefox
      caps.platform = 'Windows 8.1'
      caps.version = '26'
      caps[:name] = "Windows8.1 firefox26"
    when /\Awin_chrome/
      caps = Selenium::WebDriver::Remote::Capabilities.chrome
      caps.platform = 'Windows 8.1'
      caps.version = '31'
      caps[:name] = "Windows8.1 Chrome31"
    when /\Amac_chrome/
      caps = Selenium::WebDriver::Remote::Capabilities.chrome
      caps.platform = 'OS X 10.9'
      caps.version = '31'
      caps[:name] = "Mac OSX10.9 Chrome31"
    when /\Amac_safari/
      caps = Selenium::WebDriver::Remote::Capabilities.safari
      caps.platform = 'OS X 10.9'
      caps.version = '7'
      caps[:name] = "Mac OSX10.9 Safari7"
    end
    raise "invalid browser: <#{browser_env.inspect}>" unless (caps)
    @browser_name = caps[:name]
    @browser = Selenium::WebDriver.for(
      :remote,
      :url => @remote_driver_url,
      :desired_capabilities => caps)
  end
end

class SaucelabsTestCaseSP < SaucelabsTestCase
  def create_browser
    browser_env = ENV["BROWSER"]
    caps = nil
    case browser_env
    when /\AiOS7_landscape/
      caps = Selenium::WebDriver::Remote::Capabilities.iphone
      caps.platform = 'OS X 10.9'
      caps.version = '7'
      caps['device-orientation'] = 'landscape'
      caps[:name] = "iOS7_landscape"
    when /\AiOS7/,/\AiOS7_portrait/,nil
      caps = Selenium::WebDriver::Remote::Capabilities.iphone
      caps.platform = 'OS X 10.9'
      caps.version = '7'
      caps['device-orientation'] = 'portrait'
      caps[:name] = "iOS7_portrait"
    when /\AiOS6/,/\AiOS6_portrait/
      caps = Selenium::WebDriver::Remote::Capabilities.iphone
      caps.platform = 'OS X 10.8'
      caps.version = '6.1'
      caps['device-orientation'] = 'portrait'
      caps[:name] = "iOS6_portrait"
    when /\AAndroid/
      caps = Selenium::WebDriver::Remote::Capabilities.android
      caps.platform = 'Linux'
      caps.version = '4.0'
      caps['device-orientation'] = 'portrait'
      caps[:name] = "Android4.0"
    when /\AAndroid_tablet/
      caps = Selenium::WebDriver::Remote::Capabilities.android
      caps.platform = 'Linux'
      caps.version = '4.0'
      caps['device-type'] = 'tablet'
      caps['device-orientation'] = 'portrait'
      caps[:name] = "Android4.0(tablet)"
    end
    raise "invalid browser: <#{browser_env.inspect}>" unless (caps)
    @browser_name = caps[:name]
    @browser = Selenium::WebDriver.for(
      :remote,
      :url => @remote_driver_url,
      :desired_capabilities => caps)
  end
end
