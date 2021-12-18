require 'rails_helper'

describe LikesController do
  before do
    @user = FactoryBot.create(:user)
    @another_user = FactoryBot.create(:user)
    @cock = Cock.create(size: 15, user_id: @another_user.id)
  end

  context "when user is not logged in" do
    it "could not be able to like cocks" do
      previous_like_count = Like.count
      patch :create, params: {cock_id: @cock.id}
      expect(Like.count).to eq(previous_like_count)
      expect(response).to redirect_to login_url
    end
  end

  context "when user is logged in" do
    before do
      log_in(@user)
    end

    context "when user likes cock of another user" do
      it "should add like to the another user cock" do
        previous_like_count = Like.count
        patch :create, params: {cock_id: @cock.id}
        expect(Like.count).to eq(previous_like_count + 1)
        expect(@user.likes.find_by(post_id: @cock.id)).to be
      end

      it "should not be able to add more than one like" do
        previous_like_count = Like.count
        patch :create, params: {cock_id: @cock.id}
        expect{patch :create, params: {cock_id: @cock.id}}.to raise_error ActiveRecord::RecordNotUnique
        expect(Like.count).to eq(previous_like_count + 1)
      end
    end

    context "when user unlikes cock of another user" do
      before do  
        user_likes(@user, @another_user.cocks.find(@cock.id))
      end

      it "should unlike cock of another user" do
        previous_like_count = Like.count
        delete :destroy, params:{id: @like.id, cock_id: @cock.id}
        expect(Like.count). to eq(previous_like_count - 1)
        expect(@user.likes.find_by(post_id: @cock.id)).to be_nil
      end

      it "should not unlike cock of another user more than once" do
        previous_like_count = Like.count
        delete :destroy, params:{id: @like.id, cock_id: @cock.id}
        expect(Like.count). to eq(previous_like_count - 1)
        expect{delete :destroy, params:{id: @like.id, cock_id: @cock.id}}.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end

def log_in(user)
  session[:user_id] = user.id
end

def user_likes(user, another_user_cock)
  @like = Like.create(user_id: user.id, post_id: another_user_cock.id)
end

