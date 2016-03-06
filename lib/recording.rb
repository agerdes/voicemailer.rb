require 'net/http'

class Recording
  def initialize(url)
    @file_path = "tmp/#{Time.now.strftime('%Y-%m-%d-%H%M%S-%L')}.mp3"
    url = URI.parse(url)
    create_local_file(url, @file_path)
  end

  def create_local_file(url, path)
    file = open(path, "wb")
    begin
      Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme) do |http|
        http.request_get(url.path) do |response|
          response.read_body { |segment| file.write(segment) }
        end
      end
    ensure
      file.close
    end
  end

  def file_path
    @file_path
  end
end
