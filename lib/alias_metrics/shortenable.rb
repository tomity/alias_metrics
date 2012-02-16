class Shortenable
  attr_accessor :command
  attr_accessor :alias
  attr_accessor :count

  def initialize(alias_, command)
    self.alias = alias_.freeze
    self.command = command.freeze
    self.count = 0
  end
end
