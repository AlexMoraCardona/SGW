class Evidence < ApplicationRecord
    belongs_to :template
    belongs_to :entity
    belongs_to :evaluation_rule_detail
    has_many :firms
    has_many :participants
end
