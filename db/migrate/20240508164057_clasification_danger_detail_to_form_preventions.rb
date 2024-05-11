class ClasificationDangerDetailToFormPreventions < ActiveRecord::Migration[7.0]
  def change
    remove_column :form_preventions, :danger_prevention_id, null: true, foreign_key: true
    add_reference :form_preventions, :clasification_danger_detail, null: true, foreign_key: true
  end

end
