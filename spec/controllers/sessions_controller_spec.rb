require "rails_helper"

describe SessionsController do

  before(:each) do
    @user = FactoryBot.create(:user)
    @unactivated_user = FactoryBot.create(:unactivated_user)
  end

  context "login with invalid information" do
    it "should redirect to login" do
      get :new
      expect(response.status).to eq(200)
      post :create, params: {session: {email: "", password: ""}}
      expect(flash[:danger]).to be_truthy
      expect(response).to render_template :new
    end
  end

  context "login with valid information" do
      it "should render root if user doesnt activated" do
        post :create, params: {session: 
          {email: @unactivated_user.email, password: @unactivated_user.password}}
        expect(flash[:warning]).to be_truthy
        expect(response).to redirect_to root_url
      end

      it "login with valid information followed by logout" do
        post :create, params: {session: {email: @user.email, password: @user.password}}
        expect(response).to redirect_to @user
        expect(session[:user_id]).to eq(@user.id)
        delete :destroy
        expect(response).to redirect_to root_url
        expect(session[:user_id]).to be_nil
      end
  end

end