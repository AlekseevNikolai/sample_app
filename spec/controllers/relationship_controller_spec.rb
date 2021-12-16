require 'rails_helper'

describe RelationshipsController do
  before do
    @user = FactoryBot.create(:user)
    @another_user = FactoryBot.create(:user)
  end

  context "when user is logged in" do
    before do
      log_in(@user)
    end 

    context "when user is not following another user" do
      it "follows another user" do
        previous_relationship_count = Relationship.count
        post :create, params: {followed_id: @another_user.id}
        expect(response).to redirect_to user_path(@another_user)
        expect(@user.following).to include(@another_user)
        expect(@another_user.followers).to include(@user)
        expect(previous_relationship_count).to eq(Relationship.count - 1)
      end

      it "unfollows another user" do
        expect{unfollow(@user, @another_user)}.to raise_error(NoMethodError)
      end
    end

    context "when user allready following another user" do
      before do
        follow(@another_user)
      end

      it "follows another user again" do
        expect{follow(@another_user)}.to raise_error(ActiveRecord::RecordNotUnique)
      end

      it "unfollows another user" do
        unfollow(@user, @another_user)
        expect(@user.following).not_to include(@another_user) 
      end
    end
  end

  context "when user is not logged in"do
    it "raise error" do
      previous_relationship_count = Relationship.count
      follow(@another_user)
      expect(previous_relationship_count).to eq(Relationship.count)
      expect{unfollow(@user, @another_user)}.to raise_error(NoMethodError)
    end
  end

end

def log_in(user)
  session[:user_id] = user.id
end

def follow(another_user)
  post :create, params: {followed_id: another_user.id}
end

def unfollow(user, another_user)
  delete :destroy, params: {id: user.active_relationships.find_by(followed_id: another_user.id).id}
end
