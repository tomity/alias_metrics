module AliasLineParser
  class Zsh
    def parse(line)
      key, value = line.split(/=/)
      value = remove_single_quotes(value)
      [key, value]
    end

    def remove_single_quotes(real)
      if real[0, 1] == "'" and real[-1, 1] == "'"
        real = real[1..-2]
      end
      real
    end
  end
end
