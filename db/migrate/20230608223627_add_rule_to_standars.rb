class AddRuleToStandars < ActiveRecord::Migration[7.0]
  def change
    add_reference :standars, :rule, null: true, foreign_key: true
    add_reference :standar_details, :standar, null: true, foreign_key: true
    add_reference :standar_detail_items, :standar_detail, null: true, foreign_key: true
  end
end
