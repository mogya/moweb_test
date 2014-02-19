# -*- encoding: utf-8 -*-
require "./api/test_case_for_api.rb"

class Lasona < TestCaseForAPI
  def test_lasona_api
    params = {n:35.46372,w:139.61470,s:35.46370,e:139.61472}
    json = getJSON( 
                   url:"#{@base_url}5ILMHI/search?#{ URI.encode_www_form(params) }",
                   username:'mogya',
                   password:'mogya123'
                )
    assert_match 'OK', json[:status], "status check"
    ret = json[:results][0]
    assert_equal 78728, ret[:entry_id], "ret countains 78728."
    assert_compare ret[:latitude].to_f, '<', 50 , "lat check"
    assert_compare ret[:latitude].to_f, '>', 30 , "lat check"
    assert_compare ret[:longitude].to_f, '<', 150 , "lng check"
    assert_compare ret[:longitude].to_f, '>', 120 , "lng check"
  end
end
