# Extensions/utilities that are always available since come from the system.
require 'irb/completion'
require 'irb/ext/save-history'
require 'fileutils'
require 'pp'

# Require this as well, but capture the exception if not available.
%w[
  ap
  interactive_editor
  pry-editline
].each do |gem|
  begin
    require gem
  rescue LoadError
  end
end

IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:AUTO_INDENT] = true

# vim: set syntax=ruby:
