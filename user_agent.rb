#!/usr/bin/env ruby
require 'net/http'
require 'uri'
require 'json'
if ARGV.empty?
    puts "Error: No paramater given."
    puts "usage: ./geolocation.rb 'file with user agents'"
    exit
  end
api_data = File.read("geolocation.api.key").chomp
user_agent = ARGV[0]
web1 = "https://api.ipgeolocation.io/user-agent?apiKey="
web2 = "#{web1}#{api_data}"
uri = URI.parse(web2)
request = Net::HTTP::Get.new(uri)
request["User-Agent"] = user_agent

request_options = {
  use_ssl: uri.scheme == "https",
}
response = Net::HTTP.start(uri.hostname, uri.port, request_options) do |http|
  http.request(request)
end
body = "#{response.body}"
date = Time.now
date = date.to_i
jsonlog = "#{date}.json"
data = JSON.pretty_generate(JSON.parse(body))
puts "#{data}"
File.truncate(jsonlog, 0) if File.exist?(jsonlog)
File.open(jsonlog, 'w') {
    |file| file.write(data)
}
