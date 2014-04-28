# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)+'/../'
require "saucelabs.rb"

class Contrib < SaucelabsTestCasePC
  def test_alert
    create_browser('alert '+__FILE__)
    @browser.get(@base_url + "/contrib/")
    assert_match( /^[\s\S]*電源情報の投稿[\s\S]*$/, @browser.title)

    assert_compare( @browser.find_elements(:class, "has-error").size,'<',1 , 'has-errorの要素は最初存在しない' )
    @browser.find_element(:id, "button_form_submit").click
    assert_compare( @browser.find_elements(:class, "has-error").size,'>=',1 , '名前を入力せずにsubmitすると警告される' )
  end

  def test_cookie
    create_browser('cookie '+__FILE__)
    @browser.get(@base_url + "/contrib/")

    @browser.find_element(:id, "field_user_name").send_keys "selenium test script"
    @browser.execute_script(%Q{ jQuery("#field_user_name").blur(); })
    @browser.find_element(:id, "field_user_mail").send_keys "test@example.com"
    @browser.execute_script(%Q{ jQuery("#field_user_mail").blur(); })
    @browser.find_element(:id, "field_user_agree").click()
    @browser.execute_script(%Q{ jQuery("#field_user_agree").blur(); })
    @browser.find_element(:id, "button_form_submit").click
    assert(@browser.find_element(:id, "dialog_thankyou").displayed?,'submitするとありがとうポップアップを表示')

    cookie = @browser.manage.cookie_named('mo_user')
    assert_not_nil( cookie , 'submitすると名前やメールアドレスがcookieに保存される' )

    @browser.get(@base_url + "/contrib/")
    assert_match(
       "selenium test script",
       @browser.find_element(:id, "field_user_name").attribute('value'),
       'cookieがあれば名前が自動的に入力される'
    )
  end

  def test_doyoumean
    create_browser('doyoumean '+__FILE__)

    @browser.get(@base_url + "/contrib/")
    @browser.find_element(:id, "field_store_tel").send_keys "03-5771-1117"
    @browser.execute_script('$("#field_store_tel").change()')
    assert(@browser.find_element(:id, "dialog_doyoumean").displayed?,'既存のデータを入力しようとすると候補を表示')
  end
end
