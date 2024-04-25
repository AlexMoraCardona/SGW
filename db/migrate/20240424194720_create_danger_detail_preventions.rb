class CreateDangerDetailPreventions < ActiveRecord::Migration[7.0]
  def change
    create_table :danger_detail_preventions do |t|
      t.string :name

      t.timestamps
    end
  end
end
