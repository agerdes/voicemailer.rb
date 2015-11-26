require File.expand_path '../test_helper.rb', __FILE__

class ResponseTest < MiniTest::Test
  def record_url; "/record/#{test_number}"; end

  def test_deliver
    r = Response.deliver
    assert r.include? "I've delivered your message. Goodbye!"
  end

  def test_record_with_digits
    params = {:Digits => '5', :dialed_number => test_number}
    r = Response.record(params)
    assert r.include? "Record"
    assert r.include? "action=\"/deliver/#{test_number}\""
  end

  def test_record_without_digits
    params = { :dialed_number => test_number }
    r = Response.record(params)
    assert r.include? "I'm sorry, I didn't receive your message. Goodbye!"
    assert r.include? "Hangup"
  end

  def test_voice_no_input
    r = Response.voice(record_url)
    assert r.include? "I'm sorry, I didn't receive your message. Goodbye!"
    assert r.include? "Hangup"
  end

  def test_voice_record_instruction
    r = Response.voice(record_url)
    assert r.include? "Gather"
    assert r.include? "action=\"#{record_url}\""
    assert r.include? "numDigits=\"1\""
  end

  def test_voice_say
    ENV.delete('MP3_GREETING')
    ENV['SAY_MESSAGE'] = "This is my test message."
    r = Response.voice(record_url)
    assert r.include? "Say"
    assert r.include? ENV['SAY_MESSAGE']
  end

  def test_voice_play
    ENV.delete('SAY_MESSAGE')
    ENV['MP3_GREETING'] = "http://www.example.org"
    r = Response.voice(record_url)
    assert r.include? "Say"
    assert r.include? ENV['MP3_GREETING']
  end
end
