require "command_history"

describe CommandHistory do
  before do
    @alias_list = AliasList.load_from_lines(["l='ls -la'"])
    @history = CommandHistory.new(["l", "ls -la"], @alias_list)
  end

  it "can get the number of commands" do
    @history.commands.size.should == 2
  end

end
