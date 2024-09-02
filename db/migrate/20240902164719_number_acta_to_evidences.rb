class NumberActaToEvidences < ActiveRecord::Migration[7.0]
  def change
    add_column :evidences, :number_acta, :integer, default: 0
  end
end
