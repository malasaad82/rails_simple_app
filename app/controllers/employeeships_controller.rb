class EmployeeshipsController < ApplicationController

  def create
    listing = Listing.find(params[:listing_id])
    user = User.find(params[:user_id])
    @user_listing = Employeeship.create(user: user, listing: listing, status: 0, requested_by: current_user.id)
    flash[:info] = "#{@user_listing.user.name} was successfully added to #{@user_listing.listing.title}"
    redirect_to listing
  end


  # Update the db with one side of an accepted Employeeship request.
  # def self.accept(user, listing)
  #   request = find_by_user_id_and_listing_id(user, listing)
  #   request.status = 1
  #   request.save!
  # end

  # Delete a Employeeship or cancel a pending request.
  # def self.breakup(user, friend)
  #   destroy(find_by_user_id_and_listing_id(user, listing))
  # end

  def update
    user = params[:user_id]
    listing = params[:listing_id]
    @employeeship = Employeeship.where(user: user, listing: listing).first
    @employeeship.status = 1
    if @employeeship.update(employeeship_params)
      flash[:success] = "Employeeship was successfully accepted."
      redirect_to request.referrer
    end
  end

  def destroy
    user = params[:user_id]
    listing = params[:listing_id]
    @employeeship = Employeeship.where(user: user, listing: listing).first
    @employeeship.destroy
    flash[:success] = "Employeeship was successfully deleted."
    #redirect_to listing_path()
    redirect_to request.referrer
  end



  private
    def employeeship_params
      params.permit(:user, :listing, :status)
    end

end
