require 'spec_helper'

describe "model updater" do
  let(:user_1) { create :user, :skill => 25 }
  let(:user_2) { create :user, :skill => 50 }
  let(:user_3) { create :user, :skill => 50, :doubt => 4 }
  
  context "check if ranking scope was correctly added" do
    it "should return the ranking with the correct rating order" do
      expect(User.ranking).to eq [user_3, user_2, user_1]
    end    
  end

  context "check if the template method were added to resource model" do

    describe ".ranking" do
      it "should return 0 as de default rating for a user_1" do
        expect(user_1.rating).to eq 0
      end
      
      it "should return the result of rating algorithm" do
        expect(user_2.rating).to eq user_2.skill-3*user_2.doubt
      end
    end

    describe ".position" do
      it "should return the position of a specific resource in ranking" do
        expect(user_3.position).to eq User.ranking.index(user_3)+1
      end

      it "should confirm the first position to a specific resource in ranking" do
        expect(user_3.position).to eq 1
      end
    end
  end
end