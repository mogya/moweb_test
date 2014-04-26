# -*- encoding: utf-8 -*-
require 'bundler/setup'
require "rubygems"
require "yaml"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require 'ci/reporter/rake/test_unit_loader'

$motestdir = File.expand_path(File.dirname(__FILE__)) unless defined?($motestdir)
$saucelabs_config = YAML.load_file($motestdir+'/config/saucelabs.yml') unless defined?($saucelabs_config)

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

module LocalBrowserCreater
  def create_browser
    @browser_name = 'firefox(local)'
    @browser = Selenium::WebDriver.for :firefox
    @browser.manage.timeouts.implicit_wait = 20
  end
end
module PCBrowserCreater
  def create_browser
    browser_env = ENV["BROWSER"]
    caps = nil
    # see https://saucelabs.com/platforms for these settings.
    case browser_env
    when "win_ie6"
      caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer
      caps.platform = 'Windows XP'
      caps.version = '6'
      caps[:name] = "WindowsXP IE6"
    when "win_ie7"
      caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer
      caps.platform = 'Windows XP'
      caps.version = '7'
      caps[:name] = "WindowsXP IE7"
    when "win_ie8", nil
      caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer
      caps.platform = 'Windows XP'
      caps.version = '8'
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
      :url => $saucelabs_config['remote_driver_url'],
      :desired_capabilities => caps)
    @browser.manage.timeouts.implicit_wait = 20
  end
end

class SaucelabsTestCasePC < SaucelabsTestCase
  include PCBrowserCreater
end

module SmartphoneBrowserCreater
  def create_browser
    browser_env = ENV["BROWSER"]
    caps = nil
    # see https://saucelabs.com/platforms for these settings.
    case browser_env
    when /\AiOS7_landscape/
      caps = Selenium::WebDriver::Remote::Capabilities.iphone
      caps.platform = 'OS X 10.9'
      caps.version = '7'
      caps['device-orientation'] = 'landscape'
      caps[:name] = "iOS7_landscape"
    when /\AiOS7/,/\AiOS7_portrait/
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
    when /\AAndroid/,nil
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
      :url => $saucelabs_config['remote_driver_url'],
      :desired_capabilities => caps)
    @browser.manage.timeouts.implicit_wait = 20
  end
end

class SaucelabsTestCaseSP < SaucelabsTestCase
  include SmartphoneBrowserCreater
end

=begin
load "saucelabs.rb"
include LocalBrowserCreater ## test with local firefox browser.
# include PCBrowserCreater ## test with saucelab remote browser.
@base_url = "http://oasis.mogya.com/".freeze
create_browser
@browser.get(@base_url + "/contrib/")
=end
