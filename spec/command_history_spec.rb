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

  it "can view alias usage" do
    alias_usage = @history.alias_usages.values[0]
    alias_usage.alias.should == "l"
    alias_usage.command.should == "ls -la"
    alias_usage.count.should == 1
  end

  it "can load from ~/.zsh_history" do
    CommandHistory.load_from_zsh_history(@alias_list)
  end

  it "should store expanded commands" do
    @history.commands[0].should == "ls -la"
    @history.commands[1].should == "ls -la"
  end
end
