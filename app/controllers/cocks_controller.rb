class CocksController < ApplicationController
  include ActionView::Helpers::DateHelper
  before_action :logged_in_user, only: :create 
  # before_action :time_period, only: :create 

  def new
    @cock = Cock.new
  end

  def create
    @cock = current_user.cocks.create(size: rand(25).to_s)
    redirect_to root_url
  end

  def time_period
    if current_user.cocks.last.created_at > 2.hours.ago
      time_ago = time_ago_in_words(current_user.cocks.last.created_at)
      flash[:danger] = "You are already shared your cock size #{time_ago} ago."
      redirect_to root_url
    end
  end


end
