require 'spec_helper'

describe "model updater" do
  let(:user_1) { create :user }
  let(:user_2) { create :user }
  let(:user_3) { create :user }
  let(:user_4) { create :user }
  let(:user_5) { create :user }

  context "the users play against each other" do
    before :each do
      50.times {
        user_1.won(user_1.rating - user_2.rating)
        user_2.lost(user_2.rating - user_1.rating)
      }

      50.times {
        user_2.won(user_2.rating - user_3.rating)
        user_3.lost(user_3.rating - user_2.rating)
      }

      50.times {
        user_3.won(user_3.rating - user_4.rating)
        user_4.lost(user_4.rating - user_3.rating)
      }
    end

    it "returns the users ranking order" do
      expect(User.ranking).to eq [user_1, user_2, user_3, user_4]
    end

    it "identify a new user rating with a few matches" do
      3.times {
        user_5.won(user_5.rating - user_1.rating)
        user_1.lost(user_1.rating - user_5.rating)
      }
      2.times {
        user_5.won(user_5.rating - user_2.rating)
        user_2.lost(user_2.rating - user_5.rating)
      }
      expect(User.ranking[0]).to eq user_5
    end
  end
  
end