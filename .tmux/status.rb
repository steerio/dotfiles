#!/usr/bin/env ruby

now = Time.now
bat = nil

def FG c
  "#[fg=colour#{c}]"
end

SEP = " #{FG 240} "

begin
  pct, status = %w(capacity status).map do |path|
    File.read("/sys/class/power_supply/BAT0/#{path}").chomp
  end
  status = case status
           when 'Charging' then '▲'
           when 'Full' then ''
           else '▼'
           end
  bat = "#{FG 15}#{status}#{FG 246}#{pct}%"
rescue
end

def cache name, ttl
  fn = "#{ENV['HOME']}/.cache/tmux-status/#{name}"
  begin
    if File.stat(fn) + ttl > now
      return File.read(fn)
    end
  rescue
  end
  yield.tap do |res|
    File.open(fn, 'w') { |f| f.write res }
  end
end

class Result < Struct.new(:tag, :cases, :healed, :dead, :time)
end

require 'nokogiri'
require 'open-uri'
require 'csv'
require 'json'
require 'time'

def kraken pair
    data = JSON.parse(URI.open("https://api.kraken.com/0/public/Ticker?pair=#{pair}").read)
    res = data['result'][pair]['c'].first.to_f
    s = (res > 100 ? res.to_i : res).to_s
    s.start_with?(?0) ? s[1..-1] : s
rescue
  '?'
end

def morgenpost
  lines = %w(de de.be)
  out = []

  src = URI.open('https://funkeinteraktiv.b-cdn.net/history.light.v4.csv')
  src.each_line do |line|
    row = CSV.parse_line line
    index = lines.index row[0]
    next unless index
    prev = out[index]
    time = Time.at(row[11].to_i / 1000)

    if !prev || prev.time < time
      out[index] = Result.new(
        row[0],
        row[12].to_i,
        row[13].to_i,
        row[14].to_i,
        time
      )
    end
  end

  out
rescue
  []
end

render = proc do |result|
  time = result.time.strftime('%l%P').strip
  if now - result.time > 86400
    diff = (now.to_date - result.time.to_date).to_i
    time = "#{time}-#{diff}"
  end
  "#{FG 15}#{result.cases}#{FG 246}#{result.healed && ':'+result.healed.to_s}:#{result.dead} #{FG 240}#{time}"
end

puts [
  cache('kraken-xlm', 300) { "#{FG 246}Θ #{FG 15}#{kraken('XXLMZEUR')}" },
  cache('kraken-eth', 300) { "#{FG 246}Ξ #{FG 15}#{kraken('XETHZEUR')}" },
  cache('kraken-btc', 300) { "#{FG 246}₿ #{FG 15}#{kraken('XXBTZEUR')}" },
  # *cache('covid', 900) { morgenpost.map(&render) },
  bat
].compact.join(SEP)
