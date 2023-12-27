class ChangeColumnType < ActiveRecord::Migration[7.0]
  def change
    rename_column :administrative_political_divisions, :type, :classification
  end
end
