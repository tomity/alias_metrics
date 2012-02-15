require "alias_list"

class CommandHistory
  attr_accessor :commands
  attr_accessor :ellipsis_count

  def initialize(commands, alias_list)
    @commands = []
    @ellipsis_count = 0
    commands.each do |command|
      command_expanded = alias_list.expand_command(command)
      @ellipsis_count += command_expanded.length - command.length
      @commands << command
    end
  end

end
