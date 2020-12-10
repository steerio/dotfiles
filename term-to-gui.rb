#!/usr/bin/env ruby

require 'yaml'
require 'stringio'

def die msg
  STDERR.puts msg
  exit 1
end

pal = ARGV[0]
die "Please specify a palette on the command line." if !pal || pal == ''

fname = "#{File.dirname(__FILE__)}/palettes/#{pal}.yaml"
die "Palette #{pal} doesn't exist." unless File.exist? fname

colors = YAML.load_file(fname)['colors']

while STDIN.gets do
  if ~/^let g:colors_name\s*=\s*/
    puts "#{$&}'#{pal}'"
  elsif ~/^(hi(ghlight){0,1}\s+[A-Z][A-Za-z0-9]+\s+).*cterm[bf]g=/
    pre = $1
    # Get values
    hi = Hash[$_.chomp.scan(/([a-z]+)=([^ ]+)/)]

    ctermbg = hi['ctermbg'] && hi['ctermbg'].to_i
    if ctermbg && ctermbg > 0 && colors[ctermbg]
      hi['guibg'] = "##{colors[ctermbg]}"
    end

    ctermfg = hi['ctermfg'] && hi['ctermfg'].to_i
    if ctermfg && colors[ctermfg]
      hi['guifg'] = "##{colors[ctermfg]}"
    end

    print pre
    puts hi.map { |k,v| "#{k}=#{v}" }.join(' ')
  else
    puts $_
  end
end
