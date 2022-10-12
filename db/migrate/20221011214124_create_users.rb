class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :document
      t.string :name
      t.string :username
      t.string :email
      t.string :password_digest
      t.boolean :state, default: true
      t.integer :level, default: 0

      t.timestamps
    end
    add_index :users, :document, unique: true
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
  end
end
