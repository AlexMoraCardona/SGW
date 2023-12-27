class RemoveEvaluation < ActiveRecord::Migration[7.0]
  def change
    remove_column :history_items, :evaluation_id, :integer
  end
end
