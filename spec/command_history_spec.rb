require "alias_metrics"

describe CommandHistory do
  before do
    @alias_list = AliasList.load_from_lines(["l='ls -la'", "g=git", "ga=git add", "run-help=man"])
    @history = CommandHistory.new(["l", "l -h", "ls -la", "ls -la -h", "ga", "git add", "man"], @alias_list)
  end

  it "can get the number of commands" do
    @history.commands.size.should == 7
  end

  it "can count the number of chars shorten" do
    @history.shorten_count.should == 15 #because (`ls -la` => `l`) * 2 + (`git add` => `ga`)
  end

  it "should be count is 2 when ls -la" do
    shortenable = @history.shortenables["l"]
    shortenable.alias.should == "l"
    shortenable.command.should == "ls -la"
    shortenable.count.should == 2
  end

  it "should be count is 1 when git" do
    shortenable = @history.shortenables["g"]
    shortenable.alias.should == "g"
    shortenable.command.should == "git"
    shortenable.count.should == 1
  end

  it "should be count is 1 when git add" do
    shortenable = @history.shortenables["ga"]
    shortenable.alias.should == "ga"
    shortenable.command.should == "git add"
    shortenable.count.should == 1
  end

  it "should be count is 0 when ls -la because run-help is longer than man" do
    shortenable = @history.shortenables["run-help"]
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

  it "should be alias usage is 0 when g" do
    alias_usage = @history.alias_usages["g"]
    alias_usage.alias.should == "g"
    alias_usage.command.should == "git"
    alias_usage.count.should == 0
  end

  it "should be alias usage is 0 when ga" do
    alias_usage = @history.alias_usages["ga"]
    alias_usage.alias.should == "ga"
    alias_usage.command.should == "git add"
    alias_usage.count.should == 1
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
    @history.commands[4].should == "git add"
    @history.commands[5].should == "git add"
    @history.commands[6].should == "man"
  end

  it "should get count for fragment" do
    @history.fragment["ls"].count.should == 4
    @history.fragment["ls -la"].count.should == 4
    @history.fragment["ls -la -h"].count.should == 2
    @history.fragment["l"].count.should == 0
    @history.fragment["ga"].count.should == 0
    @history.fragment["git"].count.should == 2
    @history.fragment["git add"].count.should == 2
    @history.fragment["man"].count.should == 1
  end

  it "should get count for fragment" do
    @history.fragment["ls -la -h"].types.should == 9 * 2
    @history.fragment["ls -la -h"].shorten_types("ll").should == (9 - 2) * 2
    @history.fragment["ls -la"].types.should == 6 * 4
    @history.fragment["ls -la"].shorten_types("l").should == (6 - 1) * 4
  end
end
