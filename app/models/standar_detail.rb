class StandarDetail < ApplicationRecord
    has_many :standar_detail_items
    belongs_to :standar
end
