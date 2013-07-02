require 'spec_helper'

describe "probabilities specs" do
  let(:user_1) { create :user }
  let(:user_2) { create :user }

  context "defining a users probability when compared to another" do

    context "a users default probability" do
      it "returns the default minimum probability of 25% idependent of expected result" do
        expect(user_1.probability(true)).to eq 0.25
        expect(user_1.probability(false)).to eq 0.25
        expect(user_1.probability(0)).to eq 0.25
      end
    end

    context "a users probability after a certainly number of matches" do
      before :each do
        100.times {
          user_1.won(user_1.rating - user_2.rating)
          user_2.lost(user_2.rating - user_1.rating)
        }
      end

      it "returns the probability of 99% after 99 out 100 expected results" do
        #win expectation
        expect(user_1.probability(true)).to eq 0.99
      end

      it "returns the default minimum probability of 25% after 1 out 100 expected results" do
        #draw expectation
        expect(user_1.probability(0)).to eq 0.25
      end
    end
  end
end