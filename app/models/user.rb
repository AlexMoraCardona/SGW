class User < ApplicationRecord
    has_secure_password
    has_many :meeting_minutes
    has_one_attached :avatar
    has_one_attached :firm
    belongs_to :document
    has_many :form_preventions
    
    #validates :document, name, username, email, password_digest, state,  presence: true #Validar la presencia
    validates :document,  presence: true #Validar la presencia
    validates :name, presence: true #Validar la presencia
    validates :username,  presence: true, length: { in: 3..15}, 
    format: { with: /\A[a-z0-9A-Z]+\z/, message: :invalid} #Validar la presencia
    validates :email,  presence: true #Validar la presencia
    validates :password_digest,  presence: true #Validar la presencia
    #validates :document, uniqueness: true #Valor unico en bd
    validates :username, uniqueness: true #Valor unico en bd
    validates :email, uniqueness: true #Valor unico en bd

    validates :password_digest, length: {minimum: 4}

    before_save :downcase_attributes


    def self.label_entity(dato)
        entity = Entity.find(dato)
        name = entity.business_name if entity.present?
    end    

    def self.ransackable_attributes(auth_object = nil)
        ["name", "nro_document", "entity"]
    end 

    def label_state(dato)
        if dato == 0 ; 'INACTIVO'
        elsif  dato == 1 ; 'ACTIVO'
        end 
    end 
        
    private
    def downcase_attributes
        self.username = username.downcase 
        self.email = email.downcase 
    end  

end
