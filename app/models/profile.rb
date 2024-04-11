class Profile < ApplicationRecord
    belongs_to :user
    belongs_to :survey_profile
    belongs_to :health_promoter
    belongs_to :pension_fund
    belongs_to :occupational_risk_manager
    belongs_to :administrative_political_division

end
