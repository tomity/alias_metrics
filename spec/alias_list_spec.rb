require "alias_list"

describe AliasList do
  it "should output `ls -la` for the command `l` " do
    alias_list = AliasList.load_from_lines(["l='ls -la'"])
    alias_list.expand_command("l").should == "ls -la"
  end

  it "should output `ls` for the command `sl` " do
    alias_list = AliasList.load_from_lines(["sl=ls"])
    alias_list.expand_command("sl").should == "ls"
  end

  it "should output `ls -l` for the command `sl -l` " do
    alias_list = AliasList.load_from_lines(["sl=ls"])
    alias_list.expand_command("sl -l").should == "ls -l"
  end

  it "should output `slope` for the command `slope` because this command is slope, but is not sl" do
    alias_list = AliasList.load_from_lines(["sl=ls"])
    alias_list.expand_command("slope").should == "slope"
  end

  it "should output `ls -la` is shortenable" do
    alias_list = AliasList.load_from_lines(["l='ls -la'"])
    alias_list.shortenable?("ls -la").should == true
  end

  it "should output `ls -l` is not shortenable" do
    alias_list = AliasList.load_from_lines(["l='ls -la'"])
    alias_list.shortenable?("ls -l").should == false
  end

  it "should output `ls -l` is not shortenable" do #Is this specification correct?
    alias_list = AliasList.load_from_lines(["l='ls -la'"])
    alias_list.shortenable?("ls -al").should == false
  end

end



