#!/usr/bin/env ruby

require 'erb'

HEROKU="#{ENV['HOME']}/.heroku/heroku-client/bin/heroku"

def cmd cmdline, &blk
  STDERR.puts cmdline
  File.popen "#{HEROKU} #{cmdline}", 'r', &blk
end

pkgs, cmds, opts = [], {}, {}

def opts.add cmd, switches, doc
  self[cmd] ||= {}
  self[cmd].store switches.strip.split(/,\s+/), doc.capitalize
end

cmd 'help' do |f|
  f.each_line do |line|
    line =~ %r{([a-z0-9]+)\s+#}
    pkgs << $1 if $1
  end
end

for pkg in pkgs
  cmd "help #{pkg}" do |f|
    if f.gets =~ /^Usage: /
      f.gets # skip a line
      cmds[pkg] = f.gets.strip.capitalize
    end

    f.each_line do |line|
      if line =~ %r{^\s+([a-z0-9]+:[a-z-]+).+#\s*(.*)$}
        cmds[$1] = $2.capitalize unless $2.include?('deprecated')
      elsif line =~ %r{^\s+(-[A-Z]{0,1}[a-z, -]+).+#\s+(.+)$}
        STDERR.puts "SWITCH: #{$1}"
        opts.add pkg, $1, $2
      end
    end
  end
end

for cmd in cmds.keys
  next unless cmd.include? ':'
  cmd "help #{cmd}" do |f|
    f.each_line do |line|
      if line =~ %r{^\s+(-[A-Z]{0,1}[a-z, -]+)\s+#\s+(.+)$}
        STDERR.puts "SWITCH: #{$1}"
        opts.add cmd, $1, $2
      end
    end
  end
end

# SMART OPTS

{}.tap do |back|
  opts.keys.each do |k|
    v = opts[k]
    if kk = back[v]
      opts.delete k
      opts.delete kk
      opts["#{kk}|#{k}"] = v
    else
      back[v] = k
    end
  end
end

# OUTPUT

puts <<EOF
#compdef he

local -a _1st_arguments
_1st_arguments=(
EOF

for cmd, doc in cmds
  puts %Q{  "#{cmd.sub(':', '\\:')}:#{doc}"}
end

puts <<EOF
)

_arguments '*:: :->command'

if (( CURRENT == 1 )); then
  _describe -t commands "heroku command" _1st_arguments
  return
fi

local -a _command_args
case "$words[1]" in
EOF

for cmd in opts.keys.sort
  puts "  #{cmd})\n    _command_args=("
  for opt, doc in opts[cmd] 
    doc.gsub! '"', '\\"'
    if opt.size == 1
      puts "      '(#{opt[0]})#{opt[0]}[#{doc}]' \\"
    else
      puts "      '(#{opt.join('|')})'{#{opt.join(',')}}\"[#{doc}]\" \\"
    end
  end
  puts "    )\n    ;;"
end 

puts <<EOF
esac

_arguments \\
  $_command_args \\
  '(--app)--app[The app name]' \\
  '(--remote)--remote[The remote name]' \\
  && return 0
EOF
