require 'rails_helper'

RSpec.describe Like, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @another_user = FactoryBot.create(:user)
  end

  context "when user likes cock of another user" do
    before do
      @cock = Cock.create(size: 15, user_id: @user.id)
      @like = Like.create(user_id: @another_user.id, post_id: @cock.id)
    end

    it "should return likes of user cock" do
      expect(@user.cocks.find(@cock.id).likes).to include(@like)
    end
  end
end
