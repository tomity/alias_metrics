class CommandHistory
  attr_accessor :commands
  attr_accessor :shorten_count
  attr_accessor :shortenables
  attr_accessor :alias_usages
  attr_accessor :alias_list

  ZSH_HISTORY_FILE = "#{ENV["HOME"]}/.zsh_history"

  def initialize(commands, alias_list)
    self.alias_list = alias_list
    self.commands = []
    self.shorten_count = 0
    self.shortenables = Hash.new
    self.alias_usages = Hash.new
    alias_list.alias_hash.each_pair do |alias_, value|
      self.alias_usages[alias_] = AliasUsage.new(alias_, value)
      self.shortenables[value] = Shortenable.new(alias_, value)
    end

    commands.each do |command|
      update_shortenables(command)
      update_alias_usages(command)
      command_expanded = self.alias_list.expand_command(command)
      self.shorten_count += command_expanded.length - command.length
      self.commands << command_expanded
    end
    self.alias_list     = self.alias_list.freeze
    self.commands       = self.commands.freeze
    self.shorten_count = self.shorten_count.freeze
    self.shortenables    = self.shortenables.freeze
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

  def update_shortenables(command)
    if alias_list.shortenable?(command)
      shortenable_alias_list = alias_list.shortenable_alias(command)
      shortenable_alias_list.each do |key, value|
        self.shortenables[value].count += 1
      end
    end
  end

  def update_alias_usages(command)
    applied_alias = self.alias_list.applied_alias(command)
    applied_alias.each do |alias_, value|
      self.alias_usages[alias_].count += 1
    end
  end

end
