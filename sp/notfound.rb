# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)+'/../'
require "saucelabs.rb"

class Notfound < SaucelabsTestCaseSP
  def test_notfound
    create_browser('notfound '+__FILE__)
    @browser.get(@base_url + "sp/")
    @browser.execute_script('$("#input_keyword").val("そんな名前の駅などないのに");')
    # @browser.find_element(:id, "button_search_bystation").submit
    @browser.execute_script( %Q{ jQuery("#form_search_bystation").submit(); } )
    wait_until(/^[\s\S]*Error[\s\S]*$/){ @browser.title }
    assert_match(/^[\s\S]*Error[\s\S]*$/, @browser.title)
  end
end
