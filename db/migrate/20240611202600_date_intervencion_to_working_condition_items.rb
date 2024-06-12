class DateIntervencionToWorkingConditionItems < ActiveRecord::Migration[7.0]
  def change
    add_column :working_condition_items, :user_intervention, :integer, default: 0
    add_column :working_condition_items, :date_intervention, :date
    add_column :working_condition_items, :observation_intervention, :string
    add_column :working_condition_items, :intervention, :integer, default: 0
  end
end
