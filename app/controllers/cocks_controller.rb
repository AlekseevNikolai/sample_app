class CocksController < ApplicationController
  include ActionView::Helpers::DateHelper
  before_action :logged_in_user, only: :create 
  before_action :time_period, only: :create, if: :user_has_cocks?

  def new
    @cock = Cock.new
  end

  def create
    @cock = current_user.cocks.create(size: rand(1..25).to_s)
    redirect_to root_url
  end

  private
  def user_has_cocks?
    current_user.cocks.any?
  end

  def time_period
    if current_user.cocks.first.created_at > 2.minutes.ago
      time_ago = time_ago_in_words(current_user.cocks.first.created_at)
      flash[:danger] = "Not so fast, champ. You shared your beauty just #{time_ago} ago."
      redirect_to root_url
    end
  end
end
