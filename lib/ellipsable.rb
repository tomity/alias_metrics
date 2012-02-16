class Ellipsable
  attr_accessor :command
  attr_accessor :count

  def initialize(command, count = 1)
    @command = command.freeze
    @count = count
  end
end
