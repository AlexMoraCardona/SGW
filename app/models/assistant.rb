class Assistant < ApplicationRecord
    belongs_to :meeting_minute

    validates :name, presence: true 
end
