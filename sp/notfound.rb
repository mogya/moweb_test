# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)+'/../'
require "saucelabs.rb"

class Notfound < SaucelabsTestCaseSP  
  def test_notfound
    @browser.get(@base_url + "/sp/")
    @browser.find_element(:id, "input_keyword").clear
    @browser.find_element(:id, "input_keyword").send_keys "そんな名前の駅などないのに"
    @browser.find_element(:id, "button_search_bystation").click
    assert_match /^[\s\S]*Error[\s\S]*$/, @browser.title
  end
end
