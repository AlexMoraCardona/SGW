class AddAdminCalendarToCalendar < ActiveRecord::Migration[7.0]
  def change
    add_reference :calendars, :adm_calendar, null: false, foreign_key: true
    add_reference :activities, :calendar, null: false, foreign_key: true
    add_reference :activities, :entity, null: false, foreign_key: true
    add_reference :activities, :user, null: false, foreign_key: true
    add_reference :activity_users, :activity, null: false, foreign_key: true
    add_reference :activity_users, :user, null: false, foreign_key: true

  end
end
