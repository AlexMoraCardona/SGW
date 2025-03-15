class User < ApplicationRecord
    has_secure_password
    has_many :meeting_minutes
    has_one_attached :avatar
    has_one_attached :firm
    belongs_to :document
    has_many :form_preventions
    has_many :view_videos
    
    #validates :document, name, username, email, password_digest,  presence: true #Validar la presencia
    validates :document,  presence: true #Validar la presencia
    validates :name, presence: true #Validar la presencia
    validates :username,  presence: true, length: { in: 3..15}, 
    format: { with: /\A[a-z0-9A-Z]+\z/, message: :invalid} #Validar la presencia
    validates :email,  presence: true #Validar la presencia
    validates :password_digest,  presence: true #Validar la presencia
    validates :nro_document, uniqueness: true #Valor unico en bd
    validates :username, uniqueness: true #Valor unico en bd
    validates :email, uniqueness: true #Valor unico en bd

    validates :password_digest, length: {minimum: 6}

    before_save :downcase_attributes


    def self.label_entity(dato)
        if dato > 0 then
            entity = Entity.find(dato)
            name = entity.business_name if entity.present?
        end    
    end    

    def self.ransackable_attributes(auth_object = nil)
        ["name", "nro_document", "entity"]
    end 

    def label_state(dato)
        if dato == 0 ; 'INACTIVO'
        elsif  dato == 1 ; 'ACTIVO'
        end 
    end 

    def self.label_clasification_post(dato)
        if dato == 0 ; 'Administrativa'
        elsif  dato == 1 ; 'Operativa'
        end 
    end 


    
    
    def label_level(dato)
        if dato == 0 ; 'Sin nivel'
        elsif  dato == 1 ; 'Administrador'
        elsif  dato == 2 ; 'Asesor'
        elsif  dato == 3 ; 'Responsable SGSST'
        elsif  dato == 4 ; 'Gerente / Representante Legal'
        elsif  dato == 5 ; 'Empleado'
        end 
    end 

    def self.calculo_sex(entity)
        users = User.where("entity = ? and state = ? and level > ?", entity.id, 1, 2).order(:sex) if entity.present?
        total = users.count if users.present?
        @datos_sex = []
        if users.present? then
            users.group_by(&:sex).each  do |niv, det|
                cant = 0
                det.each do |d|
                   cant += 1 
                end  
                por = ((cant.to_f / total.to_f) * 100).round(2).to_f if total.to_f > 0

                hom = "Hombres: " +  cant.to_s  if  niv.to_i == 0
                muj = "Mujeres: " + cant.to_s if  niv.to_i == 1
                @datos_sex.push([hom, por.to_f]) if  niv.to_i == 0
                @datos_sex.push([muj, por.to_f]) if  niv.to_i == 1
            end
        end  
        return @datos_sex  
    end     

    def self.calculo_clasificacion_cargo(entity)
        users = User.where("entity = ? and state = ? and level > ?", entity.id, 1, 2).order(:clasification_post) if entity.present?
        @total_colaboradores = 0
        @datos_clasificacion_cargo = []
        if users.present? then
            users.group_by(&:clasification_post).each  do |niv, det|
                cant = 0
                det.each do |d|
                    @total_colaboradores += 1 
                   cant += 1 
                end  
                adm = "Administrativos: " +  cant.to_s  if  niv.to_i == 0
                ope = "Operarios: " + cant.to_s if  niv.to_i == 1
                @datos_clasificacion_cargo.push([adm, cant]) if  niv.to_i == 0
                @datos_clasificacion_cargo.push([ope, cant]) if  niv.to_i == 1
            end
        end  
        return @datos_clasificacion_cargo  
    end  
    
    def self.usuarios_empresa
        usuarios = User.where("entity = ?",Current.user.entity)
        return usuarios if usuarios.present?
    end    

    def self.label_name(dato)
        @nombre_usuario = User.find(dato).name
        return @nombre_usuario
    end  

    private
    def downcase_attributes
        self.username = username.downcase 
        self.email = email.downcase 
    end  

end
