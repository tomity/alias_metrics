require "alias_list"
require "ellipsable"

class CommandHistory
  attr_accessor :commands
  attr_accessor :ellipsis_count
  attr_accessor :ellipsables

  def initialize(commands, alias_list)
    @commands = []
    @ellipsis_count = 0
    @ellipsables = Hash.new

    commands.each do |command|
      if alias_list.ellipsable?(command)
        if @ellipsables.has_key?(command)
          ellipsable = @ellipsables[command]
          ellipsable.count += 1
        else
          ellipsable = Ellipsable.new(command)
          @ellipsables[command] = ellipsable
        end
      end
      command_expanded = alias_list.expand_command(command)
      @ellipsis_count += command_expanded.length - command.length
      @commands << command
    end
  end

end
