class LikesController < ApplicationController
  before_action :logged_in_user

  def create
    @cock = Cock.find(params[:cock_id])
    Like.create(user_id: current_user.id, post_id: @cock.id)
    redirect_to root_url
  end

  def destroy
    Like.find(params[:id]).destroy
    redirect_to root_url
  end

end
