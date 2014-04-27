# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)+'/../'
require "saucelabs.rb"

class Area < SaucelabsTestCaseSP
  def test_area
    s = "山門駅"
    create_browser('area '+__FILE__)
    @browser.get(@base_url + "area/")
    assert element_present?(:link, "京都府")
    @browser.find_element(:link, "京都府").click
    # ↓なぜかiOS7でJS Errorになるので回避
    # assert element_present?(:xpath, "//input[@value='#{s}']")
    # @browser.find_element(:xpath, "//input[@value='山門駅']").click
    @browser.execute_script( %Q{ jQuery("input[value='山門駅']").click(); } )

    wait_until(/#{s}/){ @browser.title }
    assert_match(/#{s}/, @browser.title)
  end

  def test_area_tokyo
    create_browser('area_tokyo '+__FILE__)

    @browser.get(@base_url + "area/")

    wait_until{ element_present?(:link, "東京都") }
    @browser.find_element(:link, "東京都").click

    wait_until{ element_present?(:link, "港区") }
    @browser.find_element(:link, "港区").click

    wait_until{ element_present?(:css,'input[value="品川駅"]') }
    @browser.execute_script( %Q{ jQuery("input[value='品川駅']").click(); } )
    # @browser.find_element(:css,'input[value="品川駅"]').click

    wait_until(/品川駅/){@browser.title}
    assert_match(/品川駅/, @browser.title)
  end

end
