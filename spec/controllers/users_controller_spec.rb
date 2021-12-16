require "rails_helper"

describe UsersController do
  before do
    @user = FactoryBot.create(:user)
    @another_user = FactoryBot.create(:user)
  end
  
  context "when user is not loged in" do
    it "could get new" do
      get :new
      expect(response.status).to eq(200)
      expect(response).to render_template :new #но почему то не могу render_tamplate signup_url, как сделано выше с login_url
    end

    it "should redirect to login from closed actions" do
    #   closed_actions = {
    #     method(:get) => :edit,
    #     method(:patch) => :update,
    #     method(:delete) =>  :destroy,
    #     method(:get) =>  :following,
    #     method(:get) => :followers 
    #   }
    #   closed_actions.each do |request, action|
    #     request.(action, params: {id: @user.id})
    #     expect(response).to redirect_to login_url
    #   end
    end

    it "rediret edit to login" do
      get :edit, params: {id: @user}
      expect(response).to redirect_to login_url
    end

    it "redirect update to login" do
      patch :update, params: {id: @user, user: @user.attributes}
      expect(response).to redirect_to login_url
    end

    it "redirect delete to login" do
      delete :destroy, params: {id: @user}
      expect(response).to redirect_to login_url
    end

    it "redirect following to login" do
      get :following, params: {id: @user}
      expect(response).to redirect_to login_url
    end

    it "redirect followers to login" do
      get :followers, params: {id: @user}
      expect(response).to redirect_to login_url
    end
  end

  context "when user is not activated" do
    before do
      @user.activated = false
    end

    context "when user is not logged in" do
      
    end
    context "when user logged in" do
      
    end
  end

  context "when user is logged in and activated," do
    before do
      log_in(@user)
    end

    context "and is not an admin," do
      it "could not open edit page of another user" do
        get :edit, params: {id: @another_user}
        expect(response).to redirect_to root_url
      end
  
      it "could not update parametrs to another user" do
        patch :edit, params: {id: @another_user}
        expect(response).to redirect_to root_url
      end

      it "could not delete users" do
        delete :destroy, params: {id: @user}
        expect(response).to redirect_to root_url
      end

      it "could open edit page of himself" do
        get :edit, params: {id: @user}
        expect(response.status).to eq(200) 
      end

      context "try to udpate parametrs," do
        it "if they are valid" do
          expect{
            patch :update, params: {id: @user.id, user: {name: "New"}}
          }.to change{@user.reload.name}.to("New")
        end

        it "if they are not valid" do
          expect{
            patch :update, params: {id: @user.id, user: {password: "123"}}
          }.not_to change{@user.reload}
        end
      end
      
    end
    
    context "when user is an admin," do
      before do
        @user.update(admin: true)
      end
      
      it "he could delete another users" do  
        delete :destroy, params: {id: @another_user}
        expect{User.find(@another_user.id)}.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end

def log_in(user)
  session[:user_id] = @user.id
end