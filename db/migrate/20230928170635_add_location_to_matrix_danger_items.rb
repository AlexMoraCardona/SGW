class AddLocationToMatrixDangerItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :matrix_danger_items, :location, null: false, foreign_key: true
  end
end
