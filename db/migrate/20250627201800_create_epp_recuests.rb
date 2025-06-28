class CreateEppRecuests < ActiveRecord::Migration[7.0]
  def change
    create_table :epp_recuests do |t|
      t.date :date_recuest
      t.integer :cantidad, default: 0
      t.integer :state_recuest, default: 0
      t.date :date_delivery
      t.string :observation

      t.timestamps
    end
    add_reference :epp_recuests, :entity, null: true, foreign_key: true
    add_reference :epp_recuests, :user, null: true, foreign_key: true
    add_reference :epp_recuests, :protection_element, null: true, foreign_key: true
  end
end
