class AddDateCreateToTrainings < ActiveRecord::Migration[7.0]
  def change
    add_column :trainings, :date_create, :date
    add_column :trainings, :date_update, :date
  end
end
