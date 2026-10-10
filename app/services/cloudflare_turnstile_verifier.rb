require "net/http"
require "uri"
require "json"

class CloudflareTurnstileVerifier
  VERIFY_URL = "https://challenges.cloudflare.com/turnstile/v0/siteverify"

  def self.verify(token, remote_ip, type: :registration)
    return false if token.blank?

    secret_key =
      if type == :login
        Rails.application.credentials.dig(
          :cloudflare_turnstile,
          :login_secret_key
        )
      else
        Rails.application.credentials.dig(
          :cloudflare_turnstile,
          :secret_key
        )
      end

    return false if secret_key.blank?

    uri = URI.parse(VERIFY_URL)

    response = Net::HTTP.post_form(
      uri,
      {
        "secret" => secret_key,
        "response" => token,
        "remoteip" => remote_ip
      }
    )

    result = JSON.parse(response.body)

    result["success"] == true

  rescue StandardError => e
    Rails.logger.error("Cloudflare Turnstile error: #{e.message}")
    false
  end
end