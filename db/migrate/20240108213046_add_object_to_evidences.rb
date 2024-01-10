class AddObjectToEvidences < ActiveRecord::Migration[7.0]
  def change
    add_column :evidences, :object, :string
  end
end
