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
    case browser_env
    when "win_ie6"
      caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer
      caps.platform = 'Windows XP'
      caps.version = '6'
      caps[:name] = "WinXP IE6 "+test_name
    when "win_ie7"
      caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer
      caps.platform = 'Windows XP'
      caps.version = '7'
      caps[:name] = "WinXP IE7 "+test_name
    when "win_ie8", nil
      caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer
      caps.platform = 'Windows XP'
      caps.version = '8'
      caps[:name] = "WinXP IE7 "+test_name
    when "win_ie_latest"
      caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer
      caps.platform = 'Windows 8.1'
      caps.version = '11'
      caps[:name] = "Win8.1 IE11 "+test_name
    when /\Awin_ff/
      caps = Selenium::WebDriver::Remote::Capabilities.firefox
      caps.platform = 'Windows 8.1'
      caps.version = '26'
      caps[:name] = "Win8.1 FF26 "+test_name
    when /\Awin_chrome/
      caps = Selenium::WebDriver::Remote::Capabilities.chrome
      caps.platform = 'Windows 8.1'
      caps.version = '31'
      caps[:name] = "Win8.1 Chrome31 "+test_name
    when /\Amac_chrome/
      caps = Selenium::WebDriver::Remote::Capabilities.chrome
      caps.platform = 'OS X 10.9'
      caps.version = '31'
      caps[:name] = "MacX10.9 Chrome31 "+test_name
    when /\Amac_safari/
      caps = Selenium::WebDriver::Remote::Capabilities.safari
      caps.platform = 'OS X 10.9'
      caps.version = '7'
      caps[:name] = "MacX10.9 Safari7 "+test_name
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
      caps['device-orientation'] = 'portrait'
      caps[:name] = "iOS "+test_name
    when /\Aios7/,/\Aios7_portrait/
      caps = Selenium::WebDriver::Remote::Capabilities.iphone
      caps.version = '7'
      caps['device-orientation'] = 'portrait'
      caps[:name] = "iOS7_portrait "+test_name
    when /\Aios7_landscape/
      caps = Selenium::WebDriver::Remote::Capabilities.iphone
      caps.version = '7'
      caps['device-orientation'] = 'landscape'
      caps[:name] = "iOS7_landscape "+test_name
    when /\Aios6/,/\Aios6_portrait/
      caps = Selenium::WebDriver::Remote::Capabilities.iphone
      caps.version = '6.1'
      caps['device-orientation'] = 'portrait'
      caps[:name] = "iOS6_portrait "+test_name
    when /\Aandroid\z/,nil
      caps = Selenium::WebDriver::Remote::Capabilities.android
      caps.version = '4.0'
      caps['device-orientation'] = 'portrait'
      caps[:name] = "Android "+test_name
    when /\Aandroid4\.?3/
      caps = Selenium::WebDriver::Remote::Capabilities.android
      caps.version = '4.3'
      caps['device-orientation'] = 'portrait'
      caps[:name] = "Android4.3 "+test_name
    when /\Aandroid4\.?2/
      caps = Selenium::WebDriver::Remote::Capabilities.android
      caps.version = '4.2'
      caps['device-orientation'] = 'portrait'
      caps[:name] = "Android4.2 "+test_name
    when /\Aandroid4\.?1/
      caps = Selenium::WebDriver::Remote::Capabilities.android
      caps.version = '4.1'
      caps['device-orientation'] = 'portrait'
      caps[:name] = "Android4.1 "+test_name
    when /\Aandroid4\z/,/\Aandroid4\.?0/
      caps = Selenium::WebDriver::Remote::Capabilities.android
      caps.version = '4.0'
      caps['device-orientation'] = 'portrait'
      caps[:name] = "Android4.0 "+test_name
    when /\Aandroid_tablet/
      caps = Selenium::WebDriver::Remote::Capabilities.android
      caps.version = '4.0'
      caps['device-type'] = 'tablet'
      caps['device-orientation'] = 'portrait'
      caps[:name] = "Android4.0(tablet) "+test_name
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
