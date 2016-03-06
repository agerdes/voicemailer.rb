class Message
  def initialize(options = {})
    options = {
      from: 'test@example.org',
      to: 'test@example.org',
      subject: 'New message from your Twilio phone system',
      body: nil,
      recording_path: nil
    }.merge(options)

    @mail = Mail.new do
      from options[:from]
      to options[:to]
      subject options[:subject]
      body options[:body]
      unless options[:recording_path].blank?
        add_file :filename => 'message.mp3',
                 :content => open(options[:recording_path]).read
      end
    end
  end

  def deliver!
    @mail.deliver!
  end
end
