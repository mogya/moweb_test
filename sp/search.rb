# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)+'/../'
require "saucelabs.rb"

class Search < SaucelabsTestCaseSP
  def test_search
    create_browser('search '+__FILE__)
    @browser.get(@base_url + "sp/")
    @browser.execute_script( %Q{ jQuery("#input_keyword").val("いわき駅"); })
    @browser.execute_script( %Q{ jQuery("#form_search_bystation").submit(); })
    wait_until(/^[\s\S]*いわき[\s\S]*$/){ @browser.title }
    assert_match(/^[\s\S]*いわき[\s\S]*$/, @browser.title)
  end
end
