require File.expand_path '../test_helper.rb', __FILE__

class Voicemailer < MiniTest::Test
  def app; Sinatra::Application; end
  def file_path; "https://www.example.com/logo.png"; end

  def test_deliver
    params = { :RecordingDuration => 123, :RecordingUrl => file_path }
    Net::HTTP.stub(:start, true, FakeHTTP.start) do
      post_signed "/deliver/#{test_number}", params
    end
    assert_equal 200, last_response.status
  end
end
