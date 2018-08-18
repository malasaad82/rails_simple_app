class RenameUserListings < ActiveRecord::Migration[5.1]
  def change
    rename_table :user_listings, :employeeships
  end
end
