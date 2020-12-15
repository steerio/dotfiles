#!/usr/bin/env ruby

require 'yaml'
require 'erb'

def die msg
  STDERR.puts msg
  exit 1
end

pal = ARGV[0]
die "Please specify a palette on the command line." if !pal || pal == ''

fname = "#{File.dirname(__FILE__)}/palettes/#{pal}.yaml"
die "Palette #{pal} doesn't exist." unless File.exist? fname

data = YAML.load_file(fname)

unless Enumerable.method_defined? :filter_map
  module Enumerable
    def filter_map &blk
      map(&blk).compact
    end
  end
end

palette = proc do
  data['colors'].filter_map do |key, value|
    pfx =
      case key
        # when 'bg' then '11'
        when 'fg' then '10'
        when '0', 0 then nil
        when Integer then "4;#{key}"
        when /([0-9]+)/ then "4;#{$1}"
        else next
      end
    "echo -ne '\\e]#{pfx};##{value}\\a'" if pfx
  end
end

puts ERB.new(DATA.read, nil, '-').result(binding)

__END__
if infocmp | grep -q 'initc='; then
  <%= palette.().join("\n  ") %>
fi

_prompt_bg=<%= data['prompt']['bg'] %>
_prompt_fg=<%= data['prompt']['fg'] %>
_prompt_bg2=<%= data['prompt']['bg2'] %>
_prompt_fg2=<%= data['prompt']['fg2'] %>

<% if data['fzf'] -%>
export FZF_DEFAULT_OPTS='<%= data['fzf'] %>'
<% end -%>
<% if data['bat_theme'] -%>
export BAT_THEME=<%= data['bat_theme'] %>
<% end -%>
<% if data['vim_cs'] -%>
export VIM_COLORSCHEME=<%= data['vim_cs'] %>
<% end -%>
