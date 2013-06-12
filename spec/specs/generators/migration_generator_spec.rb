require 'spec_helper'

describe "migration generator" do
  let(:user) { create :user }
  let(:scale) { 50.0 }
  
  context "check if the migrations updated user table" do
    it "should have the skill field and the default value" do
      user.skill.should == scale/2
    end

    it "should have the doubt field and the default value" do
      user.doubt.should == scale/6
    end

    it "should have 0 wins" do
      user.wins.should == 0
    end

    it "should have 0 losses" do
      user.losses.should == 0
    end

    it "should have 0 draws" do
      user.draws.should == 0
    end

    it "should have a serialized expectations x result field" do
      user.expectations.should_not be_nil
      user.expectations['win_expectation'].should_not be_nil
      user.expectations['lost_expectation'].should_not be_nil
      user.expectations['draw_expectation'].should_not be_nil
    end
  end
end