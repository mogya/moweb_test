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

  # ページロードが終わるまで待ちを入れる (特定ブラウザで動かない時の回避策１)
  def wait_load()
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    wait.until {
      @browser.execute_script("return document.readyState;") == "complete"
    }
  end

  # 特定の条件が成立するまで待ちを入れる (特定ブラウザで動かない時の回避策２)
  # ブロックの内容がexpectedと一致(===)するまで処理待ちを入れる
  def wait_until(expected=true)
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    wait.until {
      ret = yield
      expected === ret
    }
  end
end

class SaucelabsTestCase < Test::Unit::TestCase
  include HtmlTestSuppeter
  def initialize *args
    @base_url = "http://oasis.mogya.com/".freeze
    super
  end

  def teardown
    @browser.quit if (@browser)
  end
end

module LocalBrowserCreater
  def create_browser(test_name='')
    @browser_name = "firefox(local) "+test_name
    @browser = Selenium::WebDriver.for :firefox
    @browser.manage.timeouts.implicit_wait = 20
  end
end
module PCBrowserCreater
  def create_browser(test_name='')
    browser_env = ENV["BROWSER"]
    caps = nil
    # see https://saucelabs.com/platforms for these settings.
    # https://docs.saucelabs.com/reference/platforms-configurator/#/
    case browser_env
    when "win_ie6"
      caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer
      caps.platform = 'Windows XP'
      caps.version = '6'
      caps[:name] = "WinXP IE6 "+test_name
    when "win_ie11"
      caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer
      caps['platform'] = 'Windows 10'
      caps['version'] = '11.0'
      caps['screenResolution'] = '800x600'
      caps[:name] = "Win10 IE11 "+test_name
    when "win_ie10", nil
      caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer
      caps['platform'] = 'Windows 7'
      caps['version'] = '10.0'
      caps[:name] = "Win7 IE10 "+test_name
    when "win_edge"
      caps = Selenium::WebDriver::Remote::Capabilities.microsoftedge
      caps['platform'] = 'Windows 10'
      caps['version'] = '20.10240'
      caps[:name] = "Win10 edge20 "+test_name
    when /\Awin_ff/
      caps = Selenium::WebDriver::Remote::Capabilities.firefox
      caps['platform'] = 'Windows 10'
      caps['version'] = '41.0'
      caps[:name] = "Win FF41 "+test_name
    when /\Awin_chrome/
      caps = Selenium::WebDriver::Remote::Capabilities.chrome
      caps.platform = 'Windows 10'
      caps.version = '45.0'
      caps[:name] = "Win10 Chrome45 "+test_name
      puts 'caps name:'+caps[:name]
    when /\Amac_chrome/
      caps = Selenium::WebDriver::Remote::Capabilities.chrome
      caps['platform'] = 'OS X 10.11'
      caps['version'] = '45.0'
      caps[:name] = "MacX10.11 Chrome45 "+test_name
    when /\Amac_safari/
      caps = Selenium::WebDriver::Remote::Capabilities.safari
      caps['platform'] = 'OS X 10.11'
      caps['version'] = '8.1'
      caps[:name] = "MacX10.11 Safari8.1 "+test_name
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
  def create_browser(test_name='')
    browser_env = ENV["BROWSER"].downcase if (ENV["BROWSER"])
    caps = nil
    # see https://saucelabs.com/platforms for these settings.
    case browser_env
    when /\Aios\z/
      caps = Selenium::WebDriver::Remote::Capabilities.iphone
      caps['deviceName'] = 'iPhone 6'
      caps['deviceOrientation'] = 'portrait'
      caps[:name] = "iOS "+test_name
    when /\Aios8/,/\Aios8_portrait/
      caps = Selenium::WebDriver::Remote::Capabilities.iphone
      caps['platform'] = 'OS X 10.10'
      caps['version'] = '8.4'
      caps['deviceName'] = 'iPhone 6'
      caps['deviceOrientation'] = 'portrait'
      caps[:name] = "iOS7_portrait "+test_name
    when /\Aios9/,/\Aios9_portrait/
      caps = Selenium::WebDriver::Remote::Capabilities.iphone
      caps['platform'] = 'OS X 10.10'
      caps['version'] = '9.1'
      caps['deviceName'] = 'iPhone 6'
      caps['deviceOrientation'] = 'portrait'
      caps[:name] = "iOS7_portrait "+test_name
    when /\Aandroid\z/,nil
      caps = Selenium::WebDriver::Remote::Capabilities.android
      caps['platform'] = 'Linux'
      caps['version'] = '4.4'
      caps['deviceName'] = 'Samsung Galaxy S4 Emulator'
      caps['deviceOrientation'] = 'portrait'
      caps[:name] = "Android4.4 "+test_name
    when /\Aandroid4\.?3/
      caps = Selenium::WebDriver::Remote::Capabilities.android
      caps['platform'] = 'Linux'
      caps['version'] = '4.4'
      caps['deviceName'] = 'Samsung Galaxy S4 Emulator'
      caps['deviceOrientation'] = 'portrait'
      caps[:name] = "Android4.3 "+test_name
    when /\Aandroid4\.?2/
      caps = Selenium::WebDriver::Remote::Capabilities.android
      caps['platform'] = 'Linux'
      caps['version'] = '4.2'
      caps['deviceName'] = 'Samsung Galaxy S4 Emulator'
      caps['deviceOrientation'] = 'portrait'
      caps[:name] = "Android4.2 "+test_name
    when /\Aandroid4\.?1/
      caps = Selenium::WebDriver::Remote::Capabilities.android
      caps['platform'] = 'Linux'
      caps['version'] = '4.1'
      caps['deviceName'] = 'Samsung Galaxy S3 Emulator'
      caps['deviceOrientation'] = 'portrait'
      caps[:name] = "Android4.4 "+test_name
    when /\Aandroid_tablet/
      caps = Selenium::WebDriver::Remote::Capabilities.android
      caps['platform'] = 'Linux'
      caps['version'] = '4.4'
      caps['deviceName'] = 'Google Nexus 7 HD Emulator'
      caps['deviceOrientation'] = 'portrait'
      caps[:name] = "Android4.4(tablet) "+test_name
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
