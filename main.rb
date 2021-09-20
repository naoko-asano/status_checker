#!/usr/bin/env ruby

require "open-uri"
require "net/http"
require "csv"

urls = []
File.open("url.txt") do |file|
  file.each_line do |line|
    urls << line.chomp
  end
end

CSV.open("result.csv", "w") do |line|
  header = ["URL", "ステータス", "リダイレクト先"]
  line << header
  urls.each do |url|
    response = Net::HTTP.get_response(URI.parse(url))
    status_code = response.code.to_i
    redirect_url = response['location']
    line << [url, status_code, redirect_url]
  end
end