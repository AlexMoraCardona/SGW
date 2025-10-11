class HallazgoToMatrixActionItems < ActiveRecord::Migration[7.0]
  def change
    add_column :matrix_action_items, :hallazgo, :string
  end
end
