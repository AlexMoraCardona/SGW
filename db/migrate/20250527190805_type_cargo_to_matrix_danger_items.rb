class TypeCargoToMatrixDangerItems < ActiveRecord::Migration[7.0]
  def change
    add_column :matrix_danger_items, :type_cargo, :integer, default: 0
  end
end
