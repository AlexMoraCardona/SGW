class Entity < ApplicationRecord
    has_one_attached :logo
    has_many :evaluations
    has_many :meeting_minutes
    has_many :locations
    has_many :admin_extent_dangers  
    has_many :adm_votes 
    has_many :epp_recuests
    
    validates :email_entity, presence: true 
    validates :tax_regime, presence: true 
    validates :business_name, presence: true , if: :kind_person == 1
    validates :economic_activity, presence: true
    validates :identification_number, presence: true , if: :kind_person == 1
    validates :verification_digit, presence: true , if: :kind_person == 1
    validates :document_type_legal_representative, length: { in: 1..7 }, if: :kind_person == 0
    validates :document_number_legal_representative, presence: true, if: :kind_person == 0
    validates :first_name_legal_representative, presence: true, if: :kind_person == 0
    validates :surname_legal_representative, presence: true, if: :kind_person == 0
    validates :email_legal_representative, presence: true, if: :kind_person == 0
    validates :entity_address, presence: true 
    validates :entity_location_code, presence: true 
    validates :entity_zone, presence: true 
    validates :entity_arl, presence: true 
    validates :number_workers, presence: true 
   
    def self.label_pay(dato)
        if dato == 0 ; 'PILA MENSUAL'
        elsif dato == 1 ; 'NÓMINA MENSUAL'
        elsif dato == 2 ; 'MIXTA'
        end 
    end  

    def self.label_agricultural_unit(dato)
        if dato == 0 ; 'NO'
        elsif dato == 1 ; 'SI'
        end 
    end 

    def self.ransackable_attributes(auth_object = nil)
        ["identification_number", "business_name"]
    end 

    def self.label_name(dato)
        nombre = Entity.find(dato).business_name if dato > 0
        nombre = "Genérico" if dato == 0
        return nombre;
    end 

    def self.label_empresas
        if Current.user.level > 0 && Current.user.level < 3
            empresas = Entity.all
        else
            empresas = Entity.where("id = ?",Current.user.entity)
        end    
        return empresas;
    end 

    
    


end
