class ReviewsController < ApplicationController
  before_action :authenticate_user! ,except: :index

  def index
    @shop = Shop.find(params[:shop_id])
    @reviews = @shop.reviews
  end

  def create
    @review = current_user.reviews.new(review_params)
    if @review.save
      redirect_back(fallback_location: root_path, notice: "口コミを投稿しました")
    else
      redirect_back(fallback_location: root_path, alert: "口コミの投稿に失敗しました")
    end
  end

  def edit
    @review = Review.find(params[:id])
  end

  def destroy    
    @shop = Shop.find(params[:shop_id])
    review = @shop.reviews.find(params[:id])
    if current_user.id == review.user.id
      review.destroy
      redirect_back(fallback_location: root_path, notice: "口コミを削除しました")
    else
      render "shops/show"
    end
  end

  private

  def review_params
    params.require(:review).permit(:user_id, :shop_id, :score, :title, :content)
  end
end
