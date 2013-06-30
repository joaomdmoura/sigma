require 'spec_helper'

describe "migration generator" do
  let(:user) { create :user }
  let(:scale) { 50.0 }
  
  context "check if the migrations updated user table" do
    it "have the skill field and the default value" do
      user.skill.should == scale/2
    end

    it "have the doubt field and the default value" do
      expect(user.doubt).to eq scale/6
    end

    it "have 0 wins" do
      expect(user.wins).to eq 0
    end

    it "have 0 losses" do
      expect(user.losses).to eq 0
    end

    it "have 0 draws" do
      expect(user.draws).to eq 0
    end

    it "have a serialized expectations x result field" do
      expect(user.expectations).to_not be_nil
      expect(user.expectations['win_expectation']).to_not be_nil
      expect(user.expectations['lost_expectation']).to_not be_nil
      expect(user.expectations['draw_expectation']).to_not be_nil
    end
  end
end