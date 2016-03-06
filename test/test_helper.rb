ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'

require File.expand_path '../../app.rb', __FILE__

Dotenv.overload('.env.test')

class MiniTest::Test
  include Rack::Test::Methods
end

Mail.defaults do
  delivery_method :test
end

class FakeHTTP
  FakeResponse = Struct.new(:version, :code, :message, :body) do
    def read_body
      return yield(body)
    end
  end

  def self.start
    return self
  end

  def self.request_get(url)
    file = File.read("test/fixtures/chime.mp3")
    return yield(FakeResponse.new(1.0, 200, "OK", file))
  end
end

def sample_file(filename = "sample_file.png")
  File.new("test/fixtures/#{filename}")
end

def test_number
  ENV['NUMBER_1']
end

def wrong_number
  '12222222222'
end

def validator
  Twilio::Util::RequestValidator.new('test')
end

def sign_request(uri, params = {})
  signature = validator.build_signature_for("http://example.org#{uri}", params)
  header 'X_TWILIO_SIGNATURE', signature
end

def get_signed(uri, params = {}, env = {}, &block)
  sign_request(uri, params)
  get(uri, params, env, &block)
end

def post_signed(uri, params = {}, env = {}, &block)
  sign_request(uri, params)
  post(uri, params, env, &block)
end
