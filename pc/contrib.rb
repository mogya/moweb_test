# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)+'/../'
require "saucelabs.rb"

class Contrib < SaucelabsTestCasePC
  def test1
    @browser.get(@base_url + "/contrib/")
    assert_match( /^[\s\S]*電源情報の投稿[\s\S]*$/, @browser.title)

    assert_compare( @browser.find_elements(:class, "has-error").size,'<',1 , 'has-errorの要素は最初存在しない' )
    @browser.find_element(:id, "button_form_submit").click
    assert_compare( @browser.find_elements(:class, "has-error").size,'>=',1 , '名前を入力せずにsubmitすると警告される' )

    @browser.find_element(:id, "field_user_name").send_keys "selenium test script"
    @browser.find_element(:id, "field_user_mail").send_keys "test@example.com"
    @browser.find_element(:id, "field_user_agree").click()
    @browser.find_element(:id, "button_form_submit").click
    @browser.find_element(:id, "dialog_thankyou").displayed?

    cookie = @browser.manage.cookie_named('mo_user')
    assert_not_nil( cookie , 'submitすると名前やメールアドレスがcookieに保存される' )
    cookie[:value].sub!('selenium','cookie')
    @browser.manage.add_cookie(cookie)
    @browser.get(@base_url + "/contrib/")

    assert_match( "cookie test script", @browser.find_element(:id, "field_user_name").attribute('value') )
  end


end
