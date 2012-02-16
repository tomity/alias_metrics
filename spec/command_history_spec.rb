require "alias_metrics"

describe CommandHistory do
  before do
    @alias_list = AliasList.load_from_lines(["l='ls -la'", "ga=git add", "run-help=man"])
    @history = CommandHistory.new(["l", "l -h", "ls -la", "ls -la -h", "man"], @alias_list)
  end

  it "can get the number of commands" do
    @history.commands.size.should == 5
  end

  it "can count the number of chars shorten" do
    @history.shorten_count.should == 10 #becaulse (`ls -la` => `l`) * 2
  end

  it "should be count is 2 when ls -la" do
    shortenable = @history.shortenables["ls -la"]
    shortenable.alias.should == "l"
    shortenable.command.should == "ls -la"
    shortenable.count.should == 2
  end

  it "should be count is 0 when git add" do
    shortenable = @history.shortenables["git add"]
    shortenable.alias.should == "ga"
    shortenable.command.should == "git add"
    shortenable.count.should == 0
  end

  it "should be count is 0 when ls -la because run-help is longer than man" do
    shortenable = @history.shortenables["man"]
    shortenable.alias.should == "run-help"
    shortenable.command.should == "man"
    shortenable.count.should == 0
  end

  it "should be alias usage is 2 when l" do
    alias_usage = @history.alias_usages["l"]
    alias_usage.alias.should == "l"
    alias_usage.command.should == "ls -la"
    alias_usage.count.should == 2
  end

  it "should be alias usage is 0 when ga" do
    alias_usage = @history.alias_usages["ga"]
    alias_usage.alias.should == "ga"
    alias_usage.command.should == "git add"
    alias_usage.count.should == 0
  end

  it "should be alias usage is 0 when run-help" do
    alias_usage = @history.alias_usages["run-help"]
    alias_usage.alias.should == "run-help"
    alias_usage.command.should == "man"
    alias_usage.count.should == 0
  end

  it "can load from ~/.zsh_history" do
    CommandHistory.load_from_zsh_history(@alias_list)
  end

  it "should store expanded commands" do
    @history.commands[0].should == "ls -la"
    @history.commands[1].should == "ls -la -h"
    @history.commands[2].should == "ls -la"
    @history.commands[3].should == "ls -la -h"
    @history.commands[4].should == "man"
  end
end
