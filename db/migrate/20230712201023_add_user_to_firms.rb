class AddUserToFirms < ActiveRecord::Migration[7.0]
  def change
    add_reference :firms, :user, null: false, foreign_key: true
    add_reference :firms, :evidence, null: false, foreign_key: true
    add_reference :participants, :user, null: false, foreign_key: true
    add_reference :participants, :evidence, null: false, foreign_key: true
    add_reference :evidences, :entity, null: false, foreign_key: true
    add_reference :evidences, :template, null: false, foreign_key: true
    
  end
end
