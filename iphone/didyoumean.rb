require "rubygems"
require "selenium-webdriver"
require "test/unit"

class Didyoumean < Test::Unit::TestCase

  def setup
    @driver = Selenium::WebDriver.for :firefox
    @base_url = "http://oasis.mogya.com/"
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  def teardown
    @driver.quit
    assert_equal [], @verification_errors
  end
  
  def test_didyoumean
    @driver.get(@base_url + "/iphone/")
    @driver.find_element(:id, "input_keyword").clear
    @driver.find_element(:id, "input_keyword").send_keys "赤坂駅"
    @driver.find_element(:id, "button_search_bystation").click
    assert_match(/^[\s\S]*赤坂[\s\S]*$/, @driver.title)
    verify { assert element_present?(:xpath, "//*[@value =\"赤坂駅(福岡県福岡市中央区)\"]") }
  end
  
  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def verify(&blk)
    yield
  rescue Test::Unit::AssertionFailedError => ex
    @verification_errors << ex
  end
end
