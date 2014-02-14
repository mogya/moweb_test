# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)+'/../'
require "saucelabs.rb"

class Search < SaucelabsTestCaseSP
  def test_search
    @browser.get(@base_url + "/sp/")
    @browser.find_element(:id, "input_keyword").clear
    @browser.find_element(:id, "input_keyword").send_keys "いわき駅"
    @browser.find_element(:id, "button_search_bystation").click
    assert_match(/^[\s\S]*いわき[\s\S]*$/, @browser.title)
  end
end
