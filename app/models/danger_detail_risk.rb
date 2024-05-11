class DangerDetailRisk < ApplicationRecord
    belongs_to :clasification_danger_detail

    def self.label_risk(dato) 
        danger_detail_risk = DangerDetailRisk.find_by(clasification_danger_detail_id: dato)
        if danger_detail_risk.present? then
            label = danger_detail_risk.name
        else
            label = 'Sin Información'
        end
        return label   
    end          

end
