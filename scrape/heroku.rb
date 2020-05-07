#!/usr/bin/env ruby

# THIS CODE IS UGLY.
# But so are Heroku's help outputs.

name = ARGV[0]
unless name
  STDERR.puts "Specify command name as the sole argument (e.g. he)"
  exit 1
end

HEROKU=`which heroku`.chomp
unless $?.success?
  STDERR.puts "Heroku CLI is not installed (or not in path)"
  exit 1
end

def cmd cmdline, &blk
  STDERR.puts cmdline
  File.popen "#{HEROKU} #{cmdline}", 'r', &blk
end

class File
  def each_clean_line
    each_line do |line|
      # Seriously, Heroku?
      yield line.gsub(/\e.*?m/, '')
    end
  end
end

class String
  def cap_initial
    sub /^(.)/, &:upcase
  end
end

mode, pkgs, cmds, opts = nil, [], {}, {}

cmd 'help' do |f|
  f.each_clean_line do |line|
    if line =~ /^([A-Z]+)$/
      mode = $1.intern
    elsif mode == :COMMANDS
      line =~ %r{^  ([a-z0-9]+)}
      pkgs << $1 if $1
    end
  end
end

last_sw = nil
opt_line = proc do |key,line|
  sw = line.scan(/^\s{2}(-[a-z-]+={0,1})/)
  if sw.any?
    last_sw = sw
    sw.flatten!
    unless sw.include?('-a') || sw.include?('-r')
      begin
        desc = line.scan(/\s([a-z].+)$/i).first.first.cap_initial
      rescue
        desc = 'No description'
      end
      opts[key] ||= {}
      opts[key].store sw, desc
    end
  elsif line =~ /^\s{2}\s+([^\s]+)$/
    begin
      opts[key][last_sw] += " #{$1}"
    rescue
    end
  end
end

for pkg in pkgs
  cmd "help #{pkg}" do |f|
    cmds[pkg] = f.gets.strip.cap_initial

    last_cmd = nil
    f.each_clean_line do |line|
      if line =~ /^([A-Z]+)$/
        mode = $1.intern
      else
        case mode
        when :COMMANDS
          if line =~ %r{^\s{2}([a-z0-9:]+)\s+(.*)$}
            last_cmd = $1
            cmds[$1] = $2.cap_initial unless $2.include?('deprecated')
          elsif line =~ %r{^\s{2}\s+(.+)$}
            cmds[last_cmd] += " #{$1}"
          end
        when :OPTIONS
          opt_line.(pkg, line)
        end
      end
    end
  end
end

for cmd in cmds.keys
  next unless cmd.include? ':'
  cmd "help #{cmd}" do |f|
    f.each_clean_line do |line|
      if line =~ /^([A-Z]+)$/
        mode = $1.intern
      elsif mode == :OPTIONS
        opt_line.(cmd, line)
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
#compdef #{name}

local -a _1st_arguments
_1st_arguments=(
EOF

for cmd, doc in cmds
  puts %Q{  "#{cmd.gsub(':', '\\:')}:#{doc}"}
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
