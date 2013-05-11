require 'spec_helper'

describe "Migration Generator" do
  let(:user) { FactoryGirl.create(:user) }
  let(:scale) { 50.0 }
  
  context "Check if the migrations updated user table" do
    it "Should have the Skill field with default value" do
      user.skill.should == scale/2
    end

    it "Should have the Doubt field with default value" do
      user.doubt.should == scale/6
    end

    it "Should have 0 wins" do
      user.wins.should == 0
    end

    it "Should have 0 losses" do
      user.losses.should == 0
    end

    it "Should have 0 draws" do
      user.draws.should == 0
    end
  end
end