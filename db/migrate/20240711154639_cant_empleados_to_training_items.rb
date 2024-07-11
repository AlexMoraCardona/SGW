class CantEmpleadosToTrainingItems < ActiveRecord::Migration[7.0]
  def change
    add_column :training_items, :cant_emple, :integer, default: 0
    add_column :training_items, :cant_emple_cap, :integer, default: 0
    add_column :training_items, :cant_cap, :integer, default: 0
    add_column :training_items, :state_cap, :integer, default: 0
  end
end
