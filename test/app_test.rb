require File.expand_path '../test_helper.rb', __FILE__

class Voicemailer < MiniTest::Test
  def app; Sinatra::Application; end
  def file_path; "test/fixtures/chime"; end

  def test_voice_say
    ENV.delete('MP3_GREETING')
    ENV['SAY_MESSAGE'] = "This is my message."
    get_signed "/voice/#{test_number}"
    assert last_response.body.include? "Say"
    assert last_response.body.include? ENV['SAY_MESSAGE']
    assert last_response.body.include? "/record/#{test_number}"
  end

  def test_voice_mp3
    ENV.delete('SAY_MESSAGE')
    ENV['MP3_GREETING'] = "#{file_path}.mp3"
    get_signed "/voice/#{test_number}"
    assert last_response.body.include? "Play"
    assert last_response.body.include? ENV['MP3_GREETING']
    assert last_response.body.include? "/record/#{test_number}"
  end

  def test_record_success
    params = { :Digits => '5' }
    post_signed "/record/#{test_number}", params
    assert_equal 200, last_response.status
    assert last_response.body.include? "/deliver/#{test_number}"
  end

  def test_record_failure
    post_signed "/record/#{test_number}"
    assert_equal 200, last_response.status
    assert last_response.body.include? "I didn't receive your message"
  end

  def test_deliver
    params = { :RecordingDuration => 123, :RecordingUrl => file_path }
    post_signed "/deliver/#{test_number}", params
    assert_equal 200, last_response.status
    assert last_response.body.include? "I've delivered your message. Goodbye!"
  end
end
