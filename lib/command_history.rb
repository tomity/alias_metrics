require "alias_list"

class CommandHistory
  attr_accessor :commands

  def initialize(commands, alias_list)
    @commands = []
    commands.each do |command|
      command_expanded = alias_list.expand_command(command)
      @commands << command
    end
  end
end
