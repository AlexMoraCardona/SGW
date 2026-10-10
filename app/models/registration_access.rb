class RegistrationAccess < ApplicationRecord
  validates :ip_address, presence: true
  validates :access_count, presence: true
  validates :window_started_at, presence: true

  MAX_ACCESSES = 10
  WINDOW_DURATION = 24.hours

  def self.allow_access?(ip)
    access = find_or_initialize_by(ip_address: ip)

    if access.new_record?
      access.access_count = 1
      access.window_started_at = Time.current
      access.save!
      return true
    end

    if access.window_started_at <= WINDOW_DURATION.ago
      access.update!(
        access_count: 1,
        window_started_at: Time.current
      )
      return true
    end

    if access.access_count < MAX_ACCESSES
      access.increment!(:access_count)
      return true
    end

    false
  end
end
