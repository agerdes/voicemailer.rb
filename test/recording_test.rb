require File.expand_path '../test_helper.rb', __FILE__

class RecordingTest < MiniTest::Test
  def url; "https://www.example.com/logo.png"; end

  def setup
    Net::HTTP.stub(:start, true, FakeHTTP.start) do
      Time.stub :now, Time.at(0) do
        @recording = Recording.new(url)
        @file_path = "tmp/#{Time.now.strftime('%Y-%m-%d-%H%M%S-%L')}.mp3"
      end
    end
  end

  def test_file_path
    assert_match @file_path, @recording.file_path
  end
end
