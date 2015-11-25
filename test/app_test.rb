require File.expand_path '../test_helper.rb', __FILE__

class Voicemailer < MiniTest::Test
  def app; Sinatra::Application; end
  def file_path; "test/fixtures/chime"; end

  def test_voice
    get_signed "/voice/#{test_number}"
    assert_equal 200, last_response.status
    assert last_response.body.include? "To leave a message, press 5"
  end

  def test_deliver
    params = { :RecordingDuration => 123, :RecordingUrl => file_path }
    post_signed "/deliver/#{test_number}", params
    assert_equal 200, last_response.status
    assert last_response.body.include? "Thank you for calling."
  end
end