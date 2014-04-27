# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)+'/../'
require "saucelabs.rb"

class Netcafe < SaucelabsTestCasePC
  def test_netcafe_button
    create_browser('netcafe_button '+__FILE__)
    @browser.get(@base_url + "/")
    @browser.find_element(:id, "input_keyword").clear
    @browser.find_element(:id, "input_keyword").send_keys "新宿駅"
    @browser.find_element(:id, "keyword_submit").click
    wait_until(/^[\s\S]*新宿[\s\S]*$/){ @browser.title }
    assert_match(/^[\s\S]*新宿[\s\S]*$/, @browser.title)

    #デフォルトでネットカフェは非表示
    assert(!@browser.find_element(:class, "c_netcafe").displayed?)
    assert(@browser.find_element(:id, "button_netcafe_show").displayed?)
    assert(!@browser.find_element(:id, "button_netcafe_hide").displayed?)

    #ボタンを押すとネットカフェも表示する
    @browser.find_element(:id, "button_netcafe_show").click
    assert(@browser.find_element(:class, "c_netcafe").displayed?)
    assert(!@browser.find_element(:id, "button_netcafe_show").displayed?)
    assert(@browser.find_element(:id, "button_netcafe_hide").displayed?)

    #hideボタンを押すと非表示に戻る
    @browser.find_element(:id, "button_netcafe_hide").click
    assert(!@browser.find_element(:class, "c_netcafe").displayed?)
    assert(@browser.find_element(:id, "button_netcafe_show").displayed?)
    assert(!@browser.find_element(:id, "button_netcafe_hide").displayed?)
  end
end
