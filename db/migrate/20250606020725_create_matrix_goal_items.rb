class CreateMatrixGoalItems < ActiveRecord::Migration[7.0]
  def change
    create_table :matrix_goal_items do |t|
      t.string :objetives
      t.decimal :meta, default: 0

      t.timestamps
    end
    add_reference :matrix_goal_items, :matrix_goal, null: true, foreign_key: true
    add_reference :matrix_goal_items, :indicator, null: true, foreign_key: true
  end
end
