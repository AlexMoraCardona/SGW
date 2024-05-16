class AdmExtinguisher < ApplicationRecord
    belongs_to :user
    belongs_to :entity
    has_many :extinguishers
    
end
