#!/usr/bin/env ruby

require "net/https"
require "csv"
require "pry"

urls = []
File.open("url.txt") do |file|
  file.each_line do |line|
    urls << line.chomp
  end
end

CSV.open("result.csv", "w") do |line|
  header = ["URL", "UA", "ステータス", "リダイレクト先"]
  line << header
  urls.each do |before_url| 
    url = URI.parse(before_url)
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Get.new(url.path)

    PC = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.96 Safari/537.36"
    SP = "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1"
    user_agent = [{name: "PC", value: PC}, {name: "SP", value: SP}]
    
    user_agent.each do |ua|
      request['user-agent'] = ua[:value]
      https.start do
        response = https.request(request)
        status = response.code
        redirect_url = response["location"]
        line << [url, ua[:name], status, redirect_url]
      end
    end
  end
end
