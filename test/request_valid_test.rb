require File.expand_path '../test_helper.rb', __FILE__

class ValidatorTest < MiniTest::Test
  def app; Sinatra::Application; end
  def cases
    [['voice', 'get'], ['record', 'post'], ['deliver', 'post'], ['sms', 'post']]
  end

  def test_wrong_number
    cases.each do |route, method|
      send("#{method}_signed", "/#{route}/#{wrong_number}")
      assert_equal 404, last_response.status
    end
  end

  def test_no_number
    cases.each do |route, method|
      send("#{method}_signed", "/#{route}")
      assert_equal 404, last_response.status
    end
  end

  def test_deliver_no_duration
    params = { :RecordingUrl => "test/fixtures/chime" }
    post_signed "/deliver/#{test_number}", params
    assert_equal 400, last_response.status
  end

  def test_deliver_no_file
    params = { :RecordingDuration => "123" }
    post_signed "/deliver/#{test_number}", params
    assert_equal 400, last_response.status
  end

  def test_deliver_no_url
    params = { :RecordingDuration => "123" }
    post_signed "/deliver/#{test_number}", params
    assert_equal 400, last_response.status
  end

  def test_sms_no_from
    params = { :Body => "123" }
    post_signed "/sms/#{test_number}", params
    assert_equal 400, last_response.status
  end

  def test_sms_no_body
    params = { :From => "123" }
    post_signed "/sms/#{test_number}", params
    assert_equal 400, last_response.status
  end

  def test_not_from_twilio
    cases.each do |route, method|
      header 'X_TWILIO_SIGNATURE', nil
      send(method, "/#{route}/#{test_number}")
      assert_equal 401, last_response.status
    end
  end
end
