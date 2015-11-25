require File.expand_path '../test_helper.rb', __FILE__

class MessageTest < MiniTest::Test
  def setup
    Mail::TestMailer.deliveries.clear
    @attachment_path = 'test/fixtures/chime.mp3'
    @options = {
      subject: 'My subject',
      body: 'Hello there!',
      to: 'test@gmail.com',
      from: 'test@gmail.com',
      file_url: @attachment_path
    }
    Message.new(@options).deliver!
    @mail = Mail::TestMailer.deliveries.first
  end

  def test_message_delivered
    assert_equal 1, Mail::TestMailer.deliveries.length
  end

  def test_message_to
    assert_equal [@options[:to]], @mail.to
  end

  def test_message_from
    assert_equal [@options[:from]], @mail.from
  end

  def test_message_subject
    assert @mail.subject.include? @options[:subject]
  end

  def test_message_body
    assert_equal @options[:body], @mail.parts.first.body.decoded
  end

  def test_message_attachment
    att = Mail.new
    att.attachments['message.mp3'] = open(@attachment_path).read
    assert_equal @mail.attachments.first.decoded, att.attachments.first.decoded
  end
end
