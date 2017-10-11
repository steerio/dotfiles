#!/usr/bin/env ruby

require 'set'

def cmd cmdline, &blk
  File.popen "ipfs #{cmdline}", 'r' do |f|
    f.each_line &blk
  end
end

def help n, &blk
  cmd "#{n} --help", &blk
end

def pr indent, txt
  print (' '*indent)+txt
end

def prn indent, txt
  puts (' '*indent)+txt
end

cmds, cmdopts, subs, subopts = {}, {}, {}, {}
re_opts = /^  (-[a-z])(, (--[a-z]+)){0,1}.* - (.+?)\.*$/

cmd :help do |l|
  if l =~ /^    ([a-z]+)  +(.+)$/
    cmds.store $1, $2
  end
end

for cmd in cmds.keys do
  help cmd do |l|
    case l
    when re_opts
      cmdopts[cmd] ||= []
      cmdopts[cmd] << [$1,$3,$4]
    when /^  ipfs #{cmd} ([a-z]+).* - (.+?)\.*$/
      subs[cmd] ||= {}
      subs[cmd].store $1, $2
    end
  end
end

for cmd, vals in subs do
  for sub in vals do
    sub = sub.first
    help "#{cmd} #{sub}" do |l|
      if l =~ re_opts
        subopts[cmd] ||= {}
        subopts[cmd][sub] ||= Set.new
        subopts[cmd][sub] << [$1,$3,$4]
      end
    end
  end
end

puts <<END
#compdef ipfs

local -a _1st_arguments _arr
_1st_arguments=(
END

for cmd, desc in cmds do
  prn 2, %Q('#{cmd}:#{desc}')
end

puts <<END
)

_ipfs_subcommand () {
  local curcontext="$curcontext" state line
  typeset -A opt_args
  _arguments -C \
      ':command:->command' \
      '*::options:->options'
  case $state in
    command)
      _describe -t commands "ipfs subcommand" $1
      return
      ;;
    options)
      case $MAIN_SUBCOMMAND in
END

def opt sw, swl, desc
  if swl
    %Q/'(#{sw}|#{swl})'{#{sw},#{swl}}"[#{desc}]"/
  else
    %Q/"(#{sw})#{sw}[#{desc}]"/
  end
end

for cmd in subopts.keys do
  h = {}
  for sub, set in subopts[cmd] do
    h[set] ||= []
    h[set] << sub
  end
  prn  8, "#{cmd})"
  prn 10, 'case $line[1] in'
  for set, vals in h do
    prn 12, "#{vals.join('|')})"
    pr 14, '_arguments'
    for sw, swl, desc in set do
      puts ' \\'
      pr 16, opt(sw, swl, desc)
    end
    puts
    prn 14, ';;'
  end
  prn 10, 'esac'
  prn 10, ';;'
end

puts <<END
      esac
      ;;
  esac
}

local expl

_arguments \\
  '(-c --config)'{-c,--config}'[Path to the configuration file to use]' \\
  '(-D --debug)'{-D,--debug}'[Operate in debug mode]' \\
  '(--help)--help[Show the full command help text]' \\
  '(--h)-h[Show a short version of the command help text]' \\
  '(-L --local)'{-L,--local}'[Run the command locally, instead of using the daemon]' \\
  '(--api)--api[Overrides the routing option (dht, supernode)]' \\
  '*:: :->subcmds' && return 0

if (( CURRENT == 1 )); then
  _describe -t commands "ipfs subcommand" _1st_arguments
  return
fi

MAIN_SUBCOMMAND="$words[1]"
case $MAIN_SUBCOMMAND in
END

for cmd in (cmdopts.keys+subs.keys).uniq do
  prn 2, "#{cmd})"
  if cmdopts[cmd]
    pr 4, '_arguments'
    for sw, swl, desc in cmdopts[cmd] do
      puts ' \\'
      pr 6, opt(sw, swl, desc)
    end
    puts
  end
  if subs[cmd]
    if subs[cmd].size > 1
      prn 4, '_arr=('
      for sub, desc in subs[cmd] do
        prn 6, %Q("#{sub}:#{desc}")
      end
      prn 4, ')'
      prn 4, '_ipfs_subcommand _arr'
    else
      sub, desc = subs[cmd].first
      prn 4, %Q(_ipfs_subcommand "#{sub}:#{desc}")
    end
  end
  prn 2, ';;'
end

puts 'esac'
