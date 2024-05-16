class EntityToExtinguishers < ActiveRecord::Migration[7.0]
  def change
    remove_column :extinguishers, :user_id, null: true, foreign_key: true
    remove_column :extinguishers, :entity_id, null: true, foreign_key: true
    remove_column :extinguishers, :date_creation
    remove_column :extinguishers, :area
    remove_column :extinguishers, :firm_user
    remove_column :extinguishers, :date_firm_user
  end
end
