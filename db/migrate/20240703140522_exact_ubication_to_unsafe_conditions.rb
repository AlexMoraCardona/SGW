class ExactUbicationToUnsafeConditions < ActiveRecord::Migration[7.0]
  def change
    add_column :unsafe_conditions, :exact_ubication, :string
  end
end
