# index, show, new, edit, create, update and destroy actions
class ListingsController < ApplicationController
  before_action :logged_in_user, only: [:new, :edit, :update, :destroy]
  before_action :user_can_edit,   only: [:edit, :update, :destroy]
 
  def index
    @listings = Listing.paginate(page: params[:page]).per_page(10)
  end

  def show
    @listing = Listing.find(params[:id])
  end

  def new
    @listing = Listing.new
  end

  def edit
    @listing = Listing.find(params[:id])
  end

  def create
    @listing = Listing.new(listing_params)
    @listing.user = current_user

    if @listing.save
      flash[:success] = "Listing was successfully created."
      redirect_to listing_path(@listing)
    else
      render 'new'
    end
  end

  def update
    @listing = Listing.find(params[:id])
    if @listing.update(listing_params)
      flash[:success] = "Listing was successfully updated."
      redirect_to listing_path(@listing)
    else
      render 'edit'
    end
  end

  def destroy
    @listing = Listing.find(params[:id])
    @listing.destroy
    flash[:success] = "Listing was successfully deleted."
    redirect_to listings_path
  end

  private
    def listing_params
      params.require(:listing).permit(:title, :body)
    end

    def user_can_edit
      # @listing = Listing.find(params[:id])
      # logger.debug "User: #{@current_user.inspect}"
      # unless @listing and current_user.can_edit? @listing
      #  redirect_to root_url
      # end
      # @listing = current_user.listings.find_by(id: params[:id])
      # redirect_to root_url if @listing.nil?
      # if current_user.id not equel listing.id.user AND not_admin user SO Redirect to root.
      if current_user != Listing.find(params[:id]).user and !current_user.admin?
        redirect_to root_path
      end
    end
 

end
