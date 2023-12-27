class StandarDetailItem < ApplicationRecord
    include PgSearch::Model
    pg_search_scope :search_by_id, against: :rule_id
    pg_search_scope :search_full_text, against: {
        rule_id: 'A'
    }

    has_many :evaluation_rule_details
    belongs_to :standar_detail
end
