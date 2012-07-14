module AliasMetrics
  class AliasList
    attr_accessor :alias_hash

    class << AliasList
      def load(io, alias_line_parser)
        alias_hash = Hash::new
        io.each do |line|
          line.chomp!
          alias_, real = alias_line_parser.parse(line)
          alias_hash[alias_] = real
        end
        AliasList.new(alias_hash)
      end

      def load_from_lines(lines, alias_line_parser=AliasLineParser::Zsh.new)
        alias_hash = Hash::new
        lines.each do |line|
          alias_, real = alias_line_parser.parse(line)
          alias_hash[alias_] = real
        end
        AliasList.new(alias_hash)
      end

      def load_from_stdin(alias_line_parser=AliasLineParser::Zsh.new)
        AliasList.load(STDIN, alias_line_parser)
      end

      def load_from_file(file, alias_line_parser=AliasLineParser::Zsh.new)
        open(file) do |fh|
          AliasList.load(fh, alias_line_parser)
        end
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
      expanded = expand_command(command)
      ret = Array.new
      @alias_hash.each_pair do |alias_, real|
        if used_subcommand?(expanded, real)
          ret << expanded.sub(real, alias_) if real.length > alias_.length
        end
      end
      ret
    end

    private

    def initialize(alias_hash)
      @alias_hash = alias_hash.freeze
    end

    def used_subcommand?(command, alias_)
      command == alias_ || command.start_with?(alias_+ " ")
    end
  end
end


