class CreateFirms < ActiveRecord::Migration[7.0]
  def change
    create_table :firms do |t|
      t.integer :legal_representative, default: 0
      t.string :post
      t.integer :authorize_firm, default: 0
      t.date :date_authorize_firm

      t.timestamps
    end
  end
end
