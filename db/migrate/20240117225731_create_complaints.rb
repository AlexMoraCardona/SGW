class CreateComplaints < ActiveRecord::Migration[7.0]
  def change
    create_table :complaints do |t|
      t.integer :user_complaint, default: 0
      t.integer :user_interpose_complaint, default: 0
      t.date :date_complaint
      t.string :relationship_facts
      t.integer :have_proof, default: 0
      t.date :date_firm_complaint
      t.integer :firm_complaint, default: 0
      t.integer :state_complaint, default: 0
      t.string :observation

      t.timestamps
    end
    add_reference :complaints, :entity, null: true, foreign_key: true
  end
end
