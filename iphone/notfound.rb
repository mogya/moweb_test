require "selenium-webdriver"
require "test/unit"

class Notfound < Test::Unit::TestCase

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
  
  def test_notfound
    @driver.get(@base_url + "/iphone/")
    @driver.find_element(:id, "input_keyword").clear
    @driver.find_element(:id, "input_keyword").send_keys "そんな名前の駅などないのに"
    @driver.find_element(:id, "button_search_bystation").click
    assert_match /^[\s\S]*Error[\s\S]*$/, @driver.title
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
