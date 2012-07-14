module AliasMetrics
  class AliasList
    attr_accessor :alias_hash

    def self.load(io)
      alias_hash = Hash::new
      io.each do |line|
        line.chomp!
        alias_, real = separate_key_value_from_alias_line(line)
        alias_hash[alias_] = real
      end
      AliasList.new(alias_hash)
    end

    def self.load_from_lines(lines)
      alias_hash = Hash::new
      lines.each do |line|
        alias_, real = separate_key_value_from_alias_line(line)
        alias_hash[alias_] = real
      end
      AliasList.new(alias_hash)
    end

    def self.load_from_stdin
      AliasList.load(STDIN)
    end

    def self.load_from_file(file)
      open(file) do |fh|
        AliasList.load(fh)
      end
    end

    #NOTE: Since #command >> #alias, this process do fastly
    def expand_command(command)
      @alias_hash.each_pair do |alias_, real|
        if used_subcommand?(command, alias_)
          command = command.sub(alias_, real)
        end
      end
      command
    end

    def appliable_alias(command)
      alias_ = command.split(/\s/).first
      @alias_hash.has_key?(alias_) ? alias_ : nil
    end

    #NOTE: Since #command >> #alias, this process do fastly
    def shortenable?(command)
      @alias_hash.each_pair do |alias_, real|
        if used_subcommand?(command, real)
          return true if real.length > alias_.length
        end
      end
      false
    end

    def shortenable_alias(command)
      ret = []
      @alias_hash.each_pair do |alias_, real|
        if used_subcommand?(command, real)
          ret << alias_ if real.length > alias_.length
        end
      end
      ret
    end

    def shorten_command(command)
      ret = Array.new
      @alias_hash.each_pair do |alias_, real|
        if used_subcommand?(command, real)
          ret << command.sub(real, alias_) if real.length > alias_.length
        end
      end
      ret
    end

    private

    def initialize(alias_hash)
      @alias_hash = alias_hash.freeze
    end

    def self.separate_key_value_from_alias_line(line)
      key, value = line.split(/=/)
      value = remove_single_quotes(value)
      [key, value]
    end

    def self.remove_single_quotes(real)
      if real[0, 1] == "'" and real[-1, 1] == "'"
        real = real[1..-2]
      end
      real
    end

    def used_subcommand?(command, alias_)
      command == alias_ || command.start_with?(alias_+ " ")
    end
  end
end


