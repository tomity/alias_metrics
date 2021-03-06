require "alias_metrics"
include AliasMetrics

describe AliasList do
  let(:alias_list){ AliasList.load_from_lines(["l='ls -la'", "sl=ls", "grhh='git reset --hard HEAD\^'"]) }
  describe "expand_command" do
    it "should expand the command `l` to the command `ls -la`" do
      alias_list.expand_command("l").should == "ls -la"
    end

    it "should expand the command `l -h` to the command `ls -la -h`" do
      alias_list.expand_command("l -h").should == "ls -la -h"
    end

    it "should expand the command `sl` to the command `ls`" do
      alias_list.expand_command("sl").should == "ls"
    end

    it "should expand the command `sl -l` to the command `ls -l`" do
      alias_list.expand_command("sl -l").should == "ls -l"
    end

    it "should not expand the command `slope` to the command `lsope` because this command is not `sl`" do
      alias_list.expand_command("slope").should == "slope"
    end
  end

  describe "applied_alias" do
    it "should get the fact that command `l` can use alias `l`" do
      alias_list.appliable_alias("l").should == "l"
    end

    it "should get the fact that command `l -h` can use alias `l`" do
      alias_list.appliable_alias("l -h").should == "l"
    end
  end

  describe "shortenable" do
    it "should get the fact that `ls -la` can be shortenable" do
      alias_list.shortenable?("ls -la").should == true
    end

    it "should get the fact that `ls -la -h` can be shortenable" do
      alias_list.shortenable?("ls -la -h").should == true
    end

    it "should get the fact that `git reset --hard` can not be shortenable" do
      alias_list.shortenable?("git reset --hard").should == false
    end

    it "should get the fact that `git reset HEAD\^ --hard` can not be shortenable" do
      alias_list.shortenable?("git reset HEAD\^ --hard").should == false
    end

    it "should get the fact that `git reset --hard HEAD\^` can be shortenable" do
      alias_list.shortenable?("git reset --hard HEAD\^").should == true
    end
  end

  describe "shortenable_alias" do
    it "should get the fact the command `ls -la` can be shortenable by the alias `l`" do
      aliass = alias_list.shortenable_alias("ls -la")
      aliass.size.should == 1
      aliass.should include "l"
    end
  end

  describe "shorten_command" do
    it "should shorten the command `git reset --hard HEAD\^` to `grhh` or `g reset --hard HEAD\^`" do
      alias_list = AliasList.load_from_lines(["g=git", "grhh='git reset --hard HEAD\^'"])
      shorten_commands = alias_list.shorten_command("git reset --hard HEAD\^")
      shorten_commands.size.should == 2
      shorten_commands.should include "grhh"
      shorten_commands.should include "g reset --hard HEAD\^"
    end

    it "should shorten the command `g reset --hard HEAD\^` to `grhh` or `g reset --hard HEAD\^`" do
      alias_list = AliasList.load_from_lines(["g=git", "grhh='git reset --hard HEAD\^'"])
      shorten_commands = alias_list.shorten_command("g reset --hard HEAD\^")
      shorten_commands.size.should == 2
      shorten_commands.should include "grhh"
      shorten_commands.should include "g reset --hard HEAD\^"
    end

    it "should shorten the command `git reset --hard HEAD\^` to `grhh` or `g reset --hard HEAD\^`" do
      alias_list = AliasList.load_from_lines(["l='ls -la'", "sl=ls"])
      shorten_commands = alias_list.shorten_command("ls -la")
      shorten_commands.size.should == 1
      shorten_commands.should include "l"
    end
  end

end



