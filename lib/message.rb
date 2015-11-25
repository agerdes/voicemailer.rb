class Message
  def initialize(options = {})
    options = {
      from: 'test@example.org',
      to: 'test@example.org',
      subject: 'New message from your Twilio phone system',
      body: nil,
      file_url: nil
    }.merge(options)

    @mail = Mail.new do
      from options[:from]
      to options[:to]
      subject options[:subject]
      body options[:body]
      if options[:file_url]
        add_file :filename => 'message.mp3',
                 :content => open(options[:file_url]).read
      end
    end
  end

  def deliver!
    @mail.deliver!
  end
end
