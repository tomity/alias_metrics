class Shortenable
  attr_accessor :command
  attr_accessor :alias
  attr_accessor :count

  def initialize(alias_, command, count = 1)
    @alias = alias_.freeze
    @command = command.freeze
    @count = count
  end
end
