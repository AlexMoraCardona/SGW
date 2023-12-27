class Template < ApplicationRecord
    has_one_attached :file
    belongs_to :standar_detail_item
end
