class AliasList
  def self.load_from_lines(lines)
    alias_hash = Hash::new
    lines.each do |line|
      key, value = separate_key_value_from_alias_line(line)
      alias_hash[key] = value
    end
    AliasList.new(alias_hash)
  end

  def self.load_from_stdin
    alias_hash = Hash::new
    STDIN.each do |line|
      line.chomp!
      key, value = separate_key_value_from_alias_line(line)
      alias_hash[key] = value
    end
    AliasList.new(alias_hash)
  end

  def expand_command(command)
   @alias_hash.each_pair do |key, value|
     if command.start_with?(key + " ") or command == key
       command = command.sub(key, value)
     end
   end
   command
  end

  def ellipsable?(command)
    @alias_hash.values.each do |value|
      if command.start_with?(value + " ") or command == value
        return true
      end
    end
    false
  end

  private

  def initialize(alias_hash)
    @alias_hash = alias_hash
  end

  def self.separate_key_value_from_alias_line(line)
    key, value = line.split(/=/)
    if value[0, 1] == "'" and value[-1, 1] == "'"
      value = value[1..-2]
    end
    [key, value]
  end
end


