class AddNumberExposedContratorsToMatrixDangerItems < ActiveRecord::Migration[7.0]
  def change
    add_column :matrix_danger_items, :number_exposed_contrators, :integer
    add_column :matrix_danger_items, :number_exposed_totals, :integer
  end
end
