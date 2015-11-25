require File.expand_path '../test_helper.rb', __FILE__

class ConfigTest < MiniTest::Test
  def test_number_configuration
    number_config = {
      voice: {
        to: ENV['NUMBER_1_VOICE_TO'],
        from: ENV['NUMBER_1_VOICE_FROM']
      },
      sms: {
        to: ENV['NUMBER_1_SMS_TO'],
        from: ENV['NUMBER_1_SMS_FROM']
      }
    }
    assert_equal Config.number_configuration(ENV['NUMBER_1']), number_config
  end

  def test_remove_key_number
    key = remove_key_number("NUMBER_1_KEY")
    assert_equal key, :key
  end

  def test_remove_key_smtp
    key = remove_key_smtp("SMTP_KEY")
    assert_equal key, :key
  end

  def test_config_smtp
    smtp_config = {
      address: 'smtp.example.org',
      port: '587',
      user_name: 'test@example.org',
      password: 'secret',
      authentication: 'plain',
      enable_starttls_auto: 'true'
    }
    assert_equal Config.smtp, smtp_config
  end

  def test_config_numbers
    assert_equal 2, Config.numbers.size
    assert_includes Config.numbers, ENV["NUMBER_1"]
    assert_includes Config.numbers, ENV["NUMBER_2"]
  end
end
