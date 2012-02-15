require "command_history"

describe CommandHistory do
  before do
    @alias_list = AliasList.load_from_lines(["l='ls -la'"])
    @history = CommandHistory.new(["l", "ls -la"], @alias_list)
  end

  it "can get the number of commands" do
    @history.commands.size.should == 2
  end

  it "can count the number of chars ellipsed" do
    @history.ellipsis_count.should == 5 #becaulse `ls -la` => `l`
  end

  it "can view both count and rate of ellipsiable commands" do
    ellipsable = @history.ellipsables.values[0]
    ellipsable.command.should == "ls -la"
    ellipsable.count.should == 1
  end
end
