require "alias_list"
require "ellipsable"
require "alias_usage"

class CommandHistory
  attr_accessor :commands
  attr_accessor :ellipsis_count
  attr_accessor :ellipsables
  attr_accessor :alias_usages
  attr_accessor :alias_list

  ZSH_HISTORY_FILE = "#{ENV["HOME"]}/.zsh_history"

  def initialize(commands, alias_list)
    @alias_list = alias_list
    @commands = []
    @ellipsis_count = 0
    @ellipsables = Hash.new
    @alias_usages = Hash.new

    commands.each do |command|
      update_ellipsables(command)
      command_expanded = alias_list.expand_command(command)
      applied_alias = alias_list.applied_alias(command)
      applied_alias.each do |alias_, command|
        if @alias_usages.has_key?(command)
          alias_usage = @alias_usages[alias_]
          alias_usage.count += 1
        else
          alias_usage = AliasUsage.new(alias_, command)
          @alias_usages[alias_] = alias_usage
        end
      end
      @ellipsis_count += command_expanded.length - command.length
      @commands << command
    end
  end

  def self.load_from_zsh_history(alias_list, history_file = ZSH_HISTORY_FILE)
    commands = []
    open(history_file) do |fh|
      fh.each do |line|
        line.chomp!
        next if line == ""
        begin
          command = parse_command_by_zsh_history_line(line)
          commands << command if command
        rescue ArgumentError => e #invalid byte sequence in UTF-8
          #do nothing
        end
      end
    end
    CommandHistory.new(commands, alias_list)
  end

  private

  def self.parse_command_by_zsh_history_line(line)
    parameter, command = line.split(/;/)
    return command
  end

  def update_ellipsables(command)
    if alias_list.ellipsable?(command)
      if @ellipsables.has_key?(command)
        ellipsable = @ellipsables[command]
        ellipsable.count += 1
      else
        ellipsable = Ellipsable.new(command)
        @ellipsables[command] = ellipsable
      end
    end
  end

end
