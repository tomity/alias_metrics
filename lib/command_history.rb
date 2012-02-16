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
    self.alias_list = alias_list
    self.commands = []
    self.ellipsis_count = 0
    self.ellipsables = Hash.new
    self.alias_usages = Hash.new

    commands.each do |command|
      update_ellipsables(command)
      update_alias_usages(command)
      command_expanded = self.alias_list.expand_command(command)
      self.ellipsis_count += command_expanded.length - command.length
      self.commands << command_expanded
    end
    self.alias_list     = self.alias_list.freeze
    self.commands       = self.commands.freeze
    self.ellipsis_count = self.ellipsis_count.freeze
    self.ellipsables    = self.ellipsables.freeze
    self.alias_usages   = self.alias_usages.freeze
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
        rescue ArgumentError #invalid byte sequence in UTF-8
          #do nothing
        end
      end
    end
    CommandHistory.new(commands, alias_list)
  end

  private

  def self.parse_command_by_zsh_history_line(line)
    command = line.split(/;/)[1]
    return command
  end

  def update_ellipsables(command)
    if alias_list.ellipsable?(command)
      if self.ellipsables.has_key?(command)
        ellipsable = self.ellipsables[command]
        ellipsable.count += 1
      else
        ellipsable = Ellipsable.new(command)
        self.ellipsables[command] = ellipsable
      end
    end
  end

  def update_alias_usages(command)
    applied_alias = self.alias_list.applied_alias(command)
    applied_alias.each do |alias_, value|
      if self.alias_usages.has_key?(value)
        alias_usage = self.alias_usages[alias_]
        alias_usage.count += 1
      else
        alias_usage = AliasUsage.new(alias_, value)
        self.alias_usages[alias_] = alias_usage
      end
    end
  end

end
