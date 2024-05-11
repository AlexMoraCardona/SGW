class NoApplyToFormPreventions < ActiveRecord::Migration[7.0]
  def change
    add_column :form_preventions, :no_apply, :integer, default: 1
  end
end
