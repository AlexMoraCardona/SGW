class AreaEmployeeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :area_employee, :string
    add_reference :attendances, :user, null: true, foreign_key: true
  end
end
