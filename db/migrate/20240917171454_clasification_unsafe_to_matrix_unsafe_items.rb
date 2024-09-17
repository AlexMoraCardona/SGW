class ClasificationUnsafeToMatrixUnsafeItems < ActiveRecord::Migration[7.0]
  def change
    add_column :matrix_unsafe_items, :clasification_unsafe, :integer, default: 0
    add_column :entities, :objeto_entity, :string
  end
end
