require "rails_helper"

describe User do
  before(:all) do
    @user = FactoryBot.create(:user)
    @another_user = FactoryBot.create(:user)
  end
end