require "alias_metrics"

describe AliasList do
  before do
    @alias_list = AliasList.load_from_lines(["l='ls -la'", "sl=ls", "grhh='git reset --hard HEAD\^'"])
  end
  describe "expand_command" do
    it "should output `ls -la` for the command `l` " do
      @alias_list.expand_command("l").should == "ls -la"
    end

    it "should output `ls -la -h` for the command `l -h` " do
      @alias_list.expand_command("l -h").should == "ls -la -h"
    end

    it "should output `ls` for the command `sl` " do
      @alias_list.expand_command("sl").should == "ls"
    end

    it "should output `ls -l` for the command `sl -l` " do
      @alias_list.expand_command("sl -l").should == "ls -l"
    end

    it "should output `slope` for the command `slope` because this command is slope, but is not sl" do
      @alias_list.expand_command("slope").should == "slope"
    end
  end

  describe "shortenable" do
    it "should output `ls -la` is shortenable" do
      @alias_list.shortenable?("ls -la").should == true
    end

    it "should output `ls -la -h` for the command `l -h` " do
      @alias_list.shortenable?("ls -la -h").should == true
    end

    it "should output `git reset --hard` is not shortenable" do
      @alias_list.shortenable?("git reset --hard").should == false
    end

    it "should output `git HEAD\^ --hard` is not shortenable" do #Is this specification correct?
      @alias_list.shortenable?("git reset HEAD\^ --hard").should == false
    end
  end

end



