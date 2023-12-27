class AddOriginActionToMatrixActionItems < ActiveRecord::Migration[7.0]
  def change
    add_column :matrix_action_items, :origin_action, :integer, default: 0
  end
end
