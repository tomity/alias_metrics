
class AliasUsage
  attr_accessor :alias
  attr_accessor :command
  attr_accessor :count

  def initialize(alias_, command, count = 1)
    self.alias = alias_
    self.command = command
    self.count = count
  end

end
