class User < ApplicationRecord
    has_secure_password
    
    #validates :document, name, username, email, password_digest, state,  presence: true #Validar la presencia
    validates :document,  presence: true #Validar la presencia
    validates :name, presence: true #Validar la presencia
    validates :username,  presence: true, length: { in: 3..15}, 
    format: { with: /\A[a-z0-9A-Z]+\z/, message: :invalid} #Validar la presencia
    validates :email,  presence: true #Validar la presencia
    validates :password_digest,  presence: true #Validar la presencia
    validates :document, uniqueness: true #Valor unico en bd
    validates :username, uniqueness: true #Valor unico en bd
    validates :email, uniqueness: true #Valor unico en bd

    validates :password_digest, length: {minimum: 4}

    before_save :downcase_attributes

    private
    def downcase_attributes
        self.username = username.downcase 
        self.email = email.downcase 
    end  

end
