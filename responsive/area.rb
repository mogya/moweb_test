# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)+'/../'
require "saucelabs.rb"

class Area < SaucelabsTestCasePC
  def test_area
    create_browser('area '+__FILE__)
    @browser.get(@base_url + "area/")
    assert element_present?(:link, "京都府")
    @browser.find_element(:link, "京都府").click
    assert element_present?(:css, 'input[value="太秦駅"]')
    @browser.find_element(:css, 'input[value="太秦駅"]').click
    wait_until(/^[\s\S]*太秦駅[\s\S]*$/){ @browser.title }
    assert_match(/太秦駅/, @browser.title)
  end
  def test_area_tokyo
    create_browser('area_tokyo '+__FILE__)
    @browser.get(@base_url + "area/")
    assert element_present?(:link, "東京都")
    @browser.find_element(:link, "東京都").click
    assert element_present?(:link, "港区")
    @browser.find_element(:link, "港区").click
    assert element_present?(:css,'input[value="品川駅"]')
    @browser.find_element(:css,'input[value="品川駅"]').click
    wait_until(/^[\s\S]*品川駅[\s\S]*$/){ @browser.title }
    assert_match(/品川駅/, @browser.title)
  end

end
