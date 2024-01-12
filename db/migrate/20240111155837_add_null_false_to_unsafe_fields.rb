class AddNullFalseToUnsafeFields < ActiveRecord::Migration[7.0]
  def change
    change_column :unsafe_conditions, :not_using_equipment, :integer, default: 0
  end
end
