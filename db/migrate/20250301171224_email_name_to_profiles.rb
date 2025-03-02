class EmailNameToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :email_name, :string
  end
end
