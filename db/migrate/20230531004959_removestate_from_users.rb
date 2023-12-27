class RemovestateFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :state, :boolean
  end
end
