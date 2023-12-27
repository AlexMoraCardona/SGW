class Event < ApplicationRecord
    belongs_to :entity
    belongs_to :user
end
