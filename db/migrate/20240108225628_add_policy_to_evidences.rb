class AddPolicyToEvidences < ActiveRecord::Migration[7.0]
  def change
    add_column :evidences, :policy, :string
  end
end
