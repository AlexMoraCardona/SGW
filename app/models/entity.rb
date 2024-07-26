class Entity < ApplicationRecord
    has_one_attached :logo
    has_many :evaluations
    has_many :meeting_minutes
    has_many :locations
    has_many :admin_extent_dangers   
    
    validates :email_entity, presence: true 
    validates :tax_regime, presence: true 
    validates :business_name, presence: true , if: :kind_person == 1
    validates :first_name, presence: true , if: :kind_person == 0
    validates :surname, presence: true , if: :kind_person == 0
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
        elsif meets == 1 ; 'NÓMINA MENSUAL'
        end 
    end  

    def self.label_agricultural_unit(dato)
        if dato == 0 ; 'NO'
        elsif dato == 1 ; 'SI'
        end 
    end 
   
end
