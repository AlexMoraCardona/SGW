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
    
    def self.buscar_medida(dato, valor)
        danger_prevention =  DangerPrevention.where("clasification_danger_detail_id = ? and type_danger = ?",dato,valor).last
        if danger_prevention.present? then
            label =  danger_prevention.name
        else
            label = 'Sin Información'
        end
        return label   
    end    

    def self.label_type(dato)
        if dato == 0 ; 'ELIMINACIÓN'
        elsif dato == 1 ; 'SUSTITUCIÓN'
        elsif dato == 2 ; 'CONTROL INGENIERIA'
        elsif dato == 3 ; 'CONTROLES ADMINISTRATIVOS'
        elsif dato == 4 ; 'EPP'
        end
    end    

end
