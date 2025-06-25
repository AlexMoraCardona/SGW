class CreateInvesRecomendations < ActiveRecord::Migration[7.0]
  def change
    create_table :inves_recomendations do |t|
      t.string :recomendation
      t.integer :apply, default: 0
      t.date :date_implementation
      t.integer :responsible_implementation, default: 0
      t.date :date_verification
      t.integer :responsible_verification, default: 0

      t.timestamps
    end
    add_reference :inves_recomendations, :investigation, null: true, foreign_key: true
  end
end
