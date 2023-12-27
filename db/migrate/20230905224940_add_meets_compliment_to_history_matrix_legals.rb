class AddMeetsComplimentToHistoryMatrixLegals < ActiveRecord::Migration[7.0]
  def change
    add_column :history_matrix_legals, :meets_compliment, :integer, default: 0
    add_column :history_matrix_legals, :meets_partial, :integer, default: 0
    add_column :history_matrix_legals, :meets_earring, :integer, default: 0
  end
end
