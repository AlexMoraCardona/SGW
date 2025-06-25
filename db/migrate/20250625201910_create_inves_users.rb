class CreateInvesUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :inves_users do |t|
      t.integer :user_id, default: 0
      t.string :name
      t.string :post
      t.integer :firm, default: 0
      t.string :date_firm

      t.timestamps
    end
    add_reference :inves_users, :investigation, null: true, foreign_key: true
  end
end
