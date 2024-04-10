class CreatePensionFunds < ActiveRecord::Migration[7.0]
  def change
    create_table :pension_funds do |t|
      t.string :fund
      t.string :code_fund

      t.timestamps
    end
  end
end
