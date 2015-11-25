require File.expand_path '../test_helper.rb', __FILE__

class SMSTest < MiniTest::Test
  def app; Sinatra::Application; end

  def setup
    Mail::TestMailer.deliveries.clear
    @params = { :From => wrong_number, :Body => "This is a test SMS" }
    post_signed "/sms/#{test_number}", @params
    @mail = Mail::TestMailer.deliveries.first
  end

  def test_sms_from
    assert_equal [ENV['NUMBER_1_SMS_FROM']], @mail.from
  end

  def test_sms_subject
    assert_equal "New SMS from #{@params[:From]}", @mail.subject
  end

  def test_sms_to
    assert_equal [ENV['NUMBER_1_SMS_TO']], @mail.to
  end

  def test_sms_body
    assert_equal @params[:Body], @mail.body.decoded
  end
end
