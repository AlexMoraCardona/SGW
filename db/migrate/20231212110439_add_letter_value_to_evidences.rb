class AddLetterValueToEvidences < ActiveRecord::Migration[7.0]
  def change
    add_column :evidences, :letter_value, :string
    add_column :evidences, :value, :string
    add_column :evidences, :initial_period, :string
    add_column :evidences, :final_period, :string
  end
end
