class TypeInjureToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :affected_body, :integer, default: 0
    add_column :events, :type_injure, :integer, default: 0
    add_column :events, :accident_agent, :integer, default: 0
    add_column :events, :accident_mechanism, :integer, default: 0
    add_column :events, :name_disease, :integer, default: 0

  end
end
