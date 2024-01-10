class AddCumpliancesToEvidences < ActiveRecord::Migration[7.0]
  def change
    add_column :evidences, :compliances, :text
  end
end
