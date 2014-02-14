# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)+'/../'
require "saucelabs.rb"

class Didyoumean < SaucelabsTestCaseSP
  def test_didyoumean
    @browser.get(@base_url + "/sp/")
    @browser.find_element(:id, "input_keyword").clear
    @browser.find_element(:id, "input_keyword").send_keys "赤坂駅"
    @browser.find_element(:id, "button_search_bystation").click
    assert_match(/^[\s\S]*赤坂[\s\S]*$/, @browser.title)
    verify { assert element_present?(:xpath, "//*[@value =\"赤坂駅(福岡県福岡市中央区)\"]") }
  end
end
