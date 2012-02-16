require "alias_metrics"

describe CommandHistory do
  before do
    @alias_list = AliasList.load_from_lines(["l='ls -la'"])
    @history = CommandHistory.new(["l", "l -h", "ls -la", "ls -la -h"], @alias_list)
  end

  it "can get the number of commands" do
    @history.commands.size.should == 4
  end

  it "can count the number of chars shorten" do
    @history.shorten_count.should == 10 #becaulse (`ls -la` => `l`) * 2
  end

  it "can view both count of shortenable commands" do
    shortenable = @history.shortenables.values[0]
    shortenable.command.should == "ls -la"
    shortenable.count.should == 2
  end

  it "can view alias usage" do
    alias_usage = @history.alias_usages.values[0]
    alias_usage.alias.should == "l"
    alias_usage.command.should == "ls -la"
    alias_usage.count.should == 2
  end

  it "can load from ~/.zsh_history" do
    CommandHistory.load_from_zsh_history(@alias_list)
  end

  it "should store expanded commands" do
    @history.commands[0].should == "ls -la"
    @history.commands[1].should == "ls -la -h"
    @history.commands[2].should == "ls -la"
    @history.commands[3].should == "ls -la -h"
  end
end
