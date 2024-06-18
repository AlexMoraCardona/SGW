class DangerIntervenedToMatrixDangerItems < ActiveRecord::Migration[7.0]
  def change
    add_column :matrix_danger_items, :danger_intervened, :integer, default: 0
  end
end
