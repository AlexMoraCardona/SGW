class DetailDisease < ApplicationRecord
    belongs_to :table_disease

    def self.ransackable_attributes(auth_object = nil)
        ["name"]
    end     
end
