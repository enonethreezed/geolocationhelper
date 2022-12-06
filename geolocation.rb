#!/usr/bin/env ruby
require 'net/http'
require 'uri'
require 'json'
if ARGV.empty?
    puts "Error: No paramater given."
    puts "usage: ./geolocation.rb 'IP ADDRESS'"
    exit
  end
api_data = File.read("geolocation.api.key").chomp
web1 = "https://api.ipgeolocation.io/ipgeo?apiKey="
web2 = "&ip="
ip_address = ARGV[0]
query = "#{web1}#{api_data}#{web2}#{ip_address}"
uri = URI.parse(query)
response = Net::HTTP.get_response(uri)
data = response.body
jsonlog = "#{ip_address}.json"
data = JSON.pretty_generate(JSON.parse(data))
puts "#{data}"
File.truncate(jsonlog, 0) if File.exist?(jsonlog)
File.open(jsonlog, 'w') {
    |file| file.write(data)
}
