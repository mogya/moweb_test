# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)+'/../'
require "saucelabs.rb"

class Didyoumean < SaucelabsTestCaseSP
  def test_didyoumean
    create_browser('didyoumean '+__FILE__)
    @browser.get(@base_url + "sp/")
    wait_load
    @browser.execute_script( %Q{ jQuery("#input_keyword").val("赤坂駅"); } )
    @browser.execute_script( %Q{ jQuery("#form_search_bystation").submit(); } )

    wait_until(/^[\s\S]*赤坂[\s\S]*$/){ @browser.title }
    assert_match(/^[\s\S]*赤坂[\s\S]*$/, @browser.title)
    assert(element_present?(:xpath, "//*[@value =\"赤坂駅(福岡市営１号線)\"]") )
  end
end
