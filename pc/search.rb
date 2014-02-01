# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)+'/../'
require "saucelabs.rb"

class Search < SaucelabsTestCasePC
  def test_search1
    # STDERR.puts "[test]%s with %s"%[__method__,@browser_name]
    @browser.navigate.to  @base_url
    element = @browser.find_element(:id, "input_keyword")
    element.clear
    element.send_keys "いわき駅"
    element.submit
    assert_match /^[\s\S]*いわき[\s\S]*$/, @browser.title, "%s title match of %s"%['search1',@browser_name]

  end
end