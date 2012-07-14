module AliasMetrics
  class CommandHistory
    ZSH_HISTORY_FILE = "#{ENV["HOME"]}/.zsh_history"

    class << CommandHistory
      def load_from_zsh_history(alias_list, history_file = ZSH_HISTORY_FILE)
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
      def parse_command_by_zsh_history_line(line)
        command = line.split(/;/)[1]
        return command
      end
    end

    attr_accessor :commands
    attr_accessor :shorten_count
    attr_accessor :shortenables
    attr_accessor :alias_usages
    attr_accessor :alias_list
    attr_accessor :fragment

    def initialize(commands, alias_list)
      self.alias_list = alias_list
      self.commands = []
      self.shorten_count = 0
      self.shortenables = Hash.new
      self.alias_usages = Hash.new
      alias_list.alias_hash.each_pair do |alias_, value|
        self.alias_usages[alias_] = AliasUsage.new(alias_, value)
        self.shortenables[alias_] = Shortenable.new(alias_, value)
      end
      self.fragment = Hash.new{|h, key| h[key] = Fragment.new(key)}

      commands.each do |command|
        update_shortenables(command)
        update_alias_usages(command)
        command_expanded = self.alias_list.expand_command(command)
        self.shorten_count += [0, command_expanded.length - command.length].max
        self.commands << command_expanded
        fragments(command_expanded).each do |fragment_body|
          self.fragment[fragment_body].count += 1
        end
      end
      self.alias_list     = self.alias_list.freeze
      self.commands       = self.commands.freeze
      self.shorten_count = self.shorten_count.freeze
      self.shortenables    = self.shortenables.freeze
      self.alias_usages   = self.alias_usages.freeze
    end

    private


    def update_shortenables(command)
      if alias_list.shortenable?(command)
        shortenable_alias_list = alias_list.shortenable_alias(command)
        shortenable_alias_list.each do |alias_|
          extension = alias_list.alias_hash[alias_]
          self.shortenables[alias_].count += 1 if shortenable?(alias_, extension)
        end
      end
    end

    def update_alias_usages(command)
      alias_ = self.alias_list.appliable_alias(command)
      self.alias_usages[alias_].count += 1 if alias_
    end

    def shortenable?(alias_, command)
      command.size > alias_.size
    end

    def fragments(command)
      ret = Array.new
      units = command.split(/\s/)
      substr = units.shift
      if command_fragment?(substr)
        ret << substr
        units.each do |unit|
          break if not command_fragment?(unit)
          substr = substr + " " + unit
          ret << substr if fragment?(substr, unit)
        end
      end
      ret
    end

    def command_fragment?(unit)
      unit =~ /^[a-zA-Z\-|]+$/
    end

    def fragment?(substr, last_unit)
      !pipe?(last_unit)
    end

    def pipe?(unit)
      unit == "|"
    end
  end
end
