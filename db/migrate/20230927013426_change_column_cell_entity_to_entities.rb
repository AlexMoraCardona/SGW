class ChangeColumnCellEntityToEntities < ActiveRecord::Migration[7.0]
  def change
    change_column :entities, :cell_entity, :decimal
    change_column :locations, :cell_entity, :decimal
  end
end
