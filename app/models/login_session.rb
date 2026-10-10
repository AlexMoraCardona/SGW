class LoginSession < ApplicationRecord
  belongs_to :user

  def duration
    return nil unless started_at.present? && ended_at.present?

    ended_at - started_at
  end

  def duration_minutes
    return nil unless duration.present?

    (duration / 60).round
  end

  def self.ransackable_attributes(auth_object = nil)
    [
      "created_at",
      "ended_at",
      "id",
      "ip_address",
      "started_at",
      "updated_at",
      "user_id"
    ]
  end
end