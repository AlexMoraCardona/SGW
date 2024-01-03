class AddYearInitialToEvidences < ActiveRecord::Migration[7.0]
  def change
    add_column :evidences, :year_initial, :integer, default: 2000
    add_column :evidences, :year_final, :integer, default: 2000
  end
end
