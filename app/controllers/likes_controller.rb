class LikesController < ApplicationController
  # respond_to :js

  def create
    @like = Like.create(listing_id: params[:listing_id], user_id: current_user.id)
    @listing = @like.listing
    render :toggle
  end

  def destroy
    like = Like.where(listing_id: params[:listing_id], user_id: current_user.id).first.destroy
    @listing = like.listing
    render :toggle
  end


 end
