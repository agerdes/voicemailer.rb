require 'rubygems'
require 'twilio-ruby'
require 'mail'
require 'sinatra'
require 'open-uri'
require 'dotenv'
require_relative 'lib/message'
require_relative 'lib/config'
require_relative 'lib/response'
Dotenv.overload('.env.local', '.env', ".env.#{ENV['RACK_ENV']}")

configure do
  include Config
  set :numbers, Config.numbers
  set :validator, Twilio::Util::RequestValidator.new('test')
  settings.numbers.each do |n|
    set "config_for_#{n.to_s}", Config.number_configuration(n)
  end
  Mail.defaults { delivery_method :smtp, Config.smtp }
end

helpers do
  def request_is_for_valid_number?
    settings.numbers.include? params[:dialed_number]
  end

  def request_is_from_twilio?
    request_params = env['rack.request.form_hash'] || {}
    signature = env['HTTP_X_TWILIO_SIGNATURE'] || ''
    settings.validator.validate(request.url, request_params, signature)
  end
end

before "/*/:dialed_number" do
  error 404 unless request_is_for_valid_number?
  error 401 unless request_is_from_twilio?
end

before "/deliver/*" do
  error 400 unless ['RecordingDuration', 'RecordingUrl'].all? { |s| params.key? s }
end

before "/sms/*" do
  error 400 unless ['From', 'Body'].all? { |s| params.key? s }
end

get '/voice/:dialed_number' do
  record_url = "/record/#{params[:dialed_number]}"
  Response.voice(record_url)
end

post '/record/:dialed_number' do
  Response.record(params)
end

post '/deliver/:dialed_number' do
  file_url = "#{params[:RecordingUrl]}.mp3"
  error 400 unless File.exist?(file_url)
  options = {
    subject: "Voicemail at #{Time.now.to_s}",
    body: "Message length: #{params[:RecordingDuration]}",
    file_url: file_url
  }.merge(Config.number_configuration(params[:dialed_number])[:voice])
  Message.new(options).deliver!

  Response.deliver
end

post '/sms/:dialed_number' do
  options = {
    subject: "New SMS from #{params[:From]}",
    body: params[:Body]
  }.merge(Config.number_configuration(params[:dialed_number])[:sms])
  Message.new(options).deliver!
end
