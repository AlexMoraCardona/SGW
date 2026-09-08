class AddHelpTextToSurveillanceQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :surveillance_questions, :help_text, :text
  end
end
