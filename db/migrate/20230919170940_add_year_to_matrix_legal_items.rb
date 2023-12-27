class AddYearToMatrixLegalItems < ActiveRecord::Migration[7.0]
  def change
    add_column :matrix_legal_items, :year, :integer, default: 1900
  end
end
