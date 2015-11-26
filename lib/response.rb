require 'twilio-ruby'

class Response
  def self.build(&block)
    Twilio::TwiML::Response.new do |response|
      yield(response)
    end.text
  end

  def self.deliver
    build do |r|
      r.Say "I've delivered your message. Goodbye!"
      r.Hangup
    end
  end

  def self.record(params)
    build do |r|
      if params[:Digits] == '5'
        r.Record :action => "/deliver/#{params[:dialed_number]}"
      else
        r.Say "I'm sorry, I didn't receive your message. Goodbye!"
        r.Hangup
      end
    end
  end

  def self.voice(record_url)
    build do |r|
      r.Gather :action => record_url, :numDigits => 1 do |d|
        if ENV['MP3_GREETING']
          d.Play ENV['MP3_GREETING']
        else
          d.Say ENV['SAY_MESSAGE']
        end
      end
      r.Say "I'm sorry, I didn't receive your message. Goodbye!"
      r.Hangup
    end
  end
end
