class AddInitialTimeToEvidences < ActiveRecord::Migration[7.0]
  def change
    add_column :evidences, :initial_time, :time
    add_column :evidences, :final_time, :time
  end
end
