class ClasificationDangerToFormPreventions < ActiveRecord::Migration[7.0]
  def change
    add_reference :form_preventions, :clasification_danger, null: true, foreign_key: true
  end
end
