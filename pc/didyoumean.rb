# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)+'/../'
require "saucelabs.rb"

class Didyoumean < SaucelabsTestCasePC
  def test_didyoumean
    create_browser('didyoumean '+__FILE__)
    @browser.get(@base_url + "/")
    @browser.find_element(:id, "input_keyword").clear
    @browser.find_element(:id, "input_keyword").send_keys "赤坂駅"
    @browser.find_element(:id, "keyword_submit").click
    assert_match(/^[\s\S]*赤坂[\s\S]*$/, @browser.title)
    assert element_present?(:xpath, "//*[@value =\"赤坂駅(福岡市営１号線)\"]")
  end
end
