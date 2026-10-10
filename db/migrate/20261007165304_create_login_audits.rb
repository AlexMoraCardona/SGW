class CreateLoginAudits < ActiveRecord::Migration[7.0]
  def change

    create_table :login_audits do |t|
      t.references :user, null: true, foreign_key: true
      t.boolean :success, null: false, default: false
      t.string :ip_address
      t.string :reason

      t.timestamps
    end

    create_table :login_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :started_at, null: false
      t.datetime :ended_at
      t.string :ip_address

      t.timestamps
    end

  end
end
