class LoginAttempt < ApplicationRecord
  belongs_to :user

  MAX_FAILED_ATTEMPTS = 5

  def register_failed_attempt
    increment!(:failed_attempts)

    if failed_attempts >= MAX_FAILED_ATTEMPTS
      user.update!(state: 0)
      true
    else
      false
    end
  end

  def reset_attempts
    update!(failed_attempts: 0)
  end
end