class CreateRegistrationAccesses < ActiveRecord::Migration[7.0]
  def change
    create_table :registration_accesses do |t|
      t.string :ip_address, null: false
      t.integer :access_count, null: false, default: 0
      t.datetime :window_started_at, null: false

      t.timestamps
    end

    add_index :registration_accesses, :ip_address, unique: true
  end
end