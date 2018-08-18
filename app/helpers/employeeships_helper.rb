module EmployeeshipsHelper

  def employeeship_find(user, listing)
    Employeeship.where(:user_id => user.id, :listing_id => listing.id).first
  end

end
