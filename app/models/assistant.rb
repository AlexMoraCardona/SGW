class Assistant < ApplicationRecord
    belongs_to :meeting_minute
    belongs_to :user

    validates :name, presence: true 
end
