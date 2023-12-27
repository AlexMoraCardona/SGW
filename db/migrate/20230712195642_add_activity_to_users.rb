class AddActivityToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :activity, :string
  end
end
