class CreateDirectionReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :direction_reviews do |t|
      t.integer :user_representante, default: 0
      t.date :date_firm_representante
      t.integer :firm_representante
      t.date :date_review
      t.string :g1
      t.string :r1
      t.string :g2
      t.string :r2
      t.string :g3
      t.string :r3
      t.string :g4
      t.string :r4
      t.string :g5
      t.string :r5
      t.string :g6
      t.string :r6
      t.string :g7
      t.string :r7
      t.string :g8
      t.string :r8
      t.string :g9
      t.string :r9
      t.string :g10
      t.string :r10
      t.string :g11
      t.string :r11
      t.string :g12
      t.string :r12
      t.string :g13
      t.string :r13
      t.string :g14
      t.string :r14
      t.string :g15
      t.string :r15
      t.string :g16
      t.string :r16
      t.string :g17
      t.string :r17
      t.string :g18
      t.string :r18
      t.string :g19
      t.string :r19
      t.string :g20
      t.string :r20
      t.string :g21
      t.string :r21
      t.string :g22
      t.string :r22
      t.string :g23
      t.string :r23
      t.string :g24
      t.string :r24

      t.timestamps
    end
    add_reference :direction_reviews, :entity, null: true, foreign_key: true
    add_column :audit_report_items, :type_action, :integer, default: 0
  end
end
