class AddVersionToUnsafeConditions < ActiveRecord::Migration[7.0]
  def change
    add_column :unsafe_conditions, :version, :integer
    add_column :unsafe_conditions, :code, :string
  end
end
