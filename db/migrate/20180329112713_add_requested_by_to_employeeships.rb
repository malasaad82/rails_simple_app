class AddRequestedByToEmployeeships < ActiveRecord::Migration[5.1]
  def change
    add_column :employeeships, :requested_by, :integer
  end
end
