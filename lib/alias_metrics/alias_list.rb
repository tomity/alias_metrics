class AliasList
  attr_accessor :alias_hash

  def self.load_from_lines(lines)
    alias_hash = Hash::new
    lines.each do |line|
      alias_, real = separate_key_value_from_alias_line(line)
      alias_hash[alias_] = real
    end
    AliasList.new(alias_hash)
  end

  def self.load_from_stdin
    alias_hash = Hash::new
    STDIN.each do |line|
      line.chomp!
      alias_, real= separate_key_value_from_alias_line(line)
      alias_hash[alias_] = real
    end
    AliasList.new(alias_hash)
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

  def applied_alias(command)
   alias_ = command.split(/\s/).first
   @alias_hash.has_key?(alias_) ? alias_ : nil
  end

  #NOTE: Since #command >> #alias, this process do fastly
  def shortenable?(command)
    @alias_hash.values.each do |real|
      if used_subcommand?(command, real)
        return true
      end
    end
    false
  end

  def shortenable_alias(command)
   ret = []
   @alias_hash.each_pair do |alias_, real|
     if used_subcommand?(command, real)
       ret << [alias_, real]
     end
   end
   ret
  end

  def shorten_command(command)
    ret = Array.new
    @alias_hash.each_pair do |alias_, real|
      if used_subcommand?(command, real)
        ret << command.sub(real, alias_)
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


