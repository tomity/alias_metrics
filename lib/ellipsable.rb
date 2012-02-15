class Ellipsable
  attr_accessor :command
  attr_accessor :count

  def initialize(command, count = 1)
    @count = count
    @command = command
  end
end
