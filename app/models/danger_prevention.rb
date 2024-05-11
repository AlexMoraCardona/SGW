class DangerPrevention < ApplicationRecord
    belongs_to :clasification_danger_detail
    has_many :form_preventions

    def self.label_prevention(dato)
        danger_prevention = DangerPrevention.find_by(clasification_danger_detail_id: dato)
        if danger_prevention.present? then
            label = danger_prevention.name
        else
            label = 'Sin Información'
        end
        return label   
    end     
end
