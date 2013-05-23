require 'spec_helper'

describe "Model Updater" do
  let(:user_1) { FactoryGirl.create(:user, :skill => 25) }
  let(:user_2) { FactoryGirl.create(:user, :skill => 50) }
  let(:user_3) { FactoryGirl.create(:user, :skill => 50, :doubt => 4) }
  
  context "Check if ranking scope was correctly added" do
    it "Should return the ranking with the correct rating order" do
      User.ranking.should == [user_3, user_2, user_1]
    end    
  end

  context "Check if the template method were added to resource model" do

    context "Rating method" do
      it "Should return 0 as de default rating for a user_1" do
        user_1.rating.should == 0
      end
      
      it "Should return the result of rating algorithm" do
        user_2.rating.should == user_2.skill - 3 * user_2.doubt
      end
    end

    context "Position method" do
      it "Should return the position of a specific resource in ranking" do
        user_3.position.should == User.ranking.index(user_3)+1
      end

      it "Should confirm the first position to a specific resource in ranking" do
        user_3.position.should == 1
      end
    end
  end
end