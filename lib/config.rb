module Config
  def auth_token
    return ENV['TWILIO_AUTH_TOKEN']
  end

  def remove_key_smtp(k)
    k[5..-1].downcase.to_sym
  end

  def remove_key_number(k)
    k.gsub(/NUMBER_\d_/,'').downcase.to_sym
  end

  def display_number(n)
    Config.numbers.index(n)+1
  end

  def env_for_number(n)
    ENV.select { |k| k.include?("NUMBER_#{display_number(n)}_") }
  end

  def self.number_configuration(n)
    env_for_number(n).inject({}) do |res, (k, v)|
      protocol, role = remove_key_number(k).to_s.split('_')
      res.merge!(protocol.to_sym => { role.to_sym => v }) do |key, v1, v2|
        key = v1.merge!(v2)
      end
    end
  end

  def self.numbers
    ENV.select {|k| k =~ /NUMBER_\d\z/}.values.to_a
  end

  def self.smtp
    ENV.select { |k| k.include?('SMTP_') }.
        map { |k,v| [remove_key_smtp(k),v] }.
        to_h
  end
end
