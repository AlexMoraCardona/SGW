class User < ApplicationRecord
    has_secure_password
    has_many :meeting_minutes
    has_one_attached :avatar
    has_one_attached :firm
    belongs_to :document
    has_many :form_preventions
    has_many :view_videos
    has_many :candidate_votes
    has_many :habil_votes
    has_many :votes
    has_many :epp_recuests
    
    #validates :document, name, username, email, password_digest,  presence: true #Validar la presencia
    validates :document,  presence: true #Validar la presencia
    validates :name, presence: true #Validar la presencia
    validates :username,  presence: true, length: { in: 3..20}, 
    format: { with: /\A[a-z0-9A-Z]+\z/, message: :invalid} #Validar la presencia
    validates :email,  presence: true #Validar la presencia
    validates :password_digest,  presence: true #Validar la presencia
    validates :nro_document, uniqueness: true #Valor unico en bd
    validates :username, uniqueness: true #Valor unico en bd
    validates :email, uniqueness: true #Valor unico en bd

    validates :password_digest, length: {minimum: 6}
    #validates :password, length: {minimum: 6}

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

    def self.label_politica(dato)
        if dato == 0 ; 'NO'
        elsif  dato == 1 ; 'SI'
        end 
    end 

    def self.actualizalogin(id)
        user = User.find(id)
        user.ultima_date_login = DateTime.now 
        user.save
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
        users = User.where("entity = ? and state = ? and level > ?", entity, 1, 2).order(:sex) if entity.present?
        total = users.count if users.present?
        datos_sex = []
        if users.present? then
            users.group_by(&:sex).each  do |niv, det|
                cant = 0
                det.each do |d|
                   cant += 1 
                end  
                por = ((cant.to_f / total.to_f) * 100).round(2).to_f if total.to_f > 0

                hom = "Hombres: " +  cant.to_s  if  niv.to_i == 0
                muj = "Mujeres: " + cant.to_s if  niv.to_i == 1
                datos_sex.push([hom, por.to_f]) if  niv.to_i == 0
                datos_sex.push([muj, por.to_f]) if  niv.to_i == 1
            end
        end  
        return datos_sex  
    end     

    def self.calculo_clasificacion_cargo(entity)
        users = User.where("entity = ? and state = ? and level > ?", entity, 1, 2).order(:clasification_post) if entity.present?
        total_colaboradores = users.count if users.present?
        datos_clasificacion_cargo = []
        if users.present? then
            users.group_by(&:clasification_post).each  do |niv, det|
                cant = 0
                det.each do |d|
                   cant += 1 
                end  
                adm = "Administrativos: " +  cant.to_s  if  niv.to_i == 0
                ope = "Operarios: " + cant.to_s if  niv.to_i == 1
                por = 0
                por = (cant.to_f / total_colaboradores.to_f) * 100 if total_colaboradores.present? 
                datos_clasificacion_cargo.push([adm, por.round(2).to_f]) if  niv.to_i == 0
                datos_clasificacion_cargo.push([ope, por.round(2).to_f]) if  niv.to_i == 1
            end
        end 
        return datos_clasificacion_cargo  
    end  
    
    def self.usuarios_empresa
        usuarios = User.where("entity = ?",Current.user.entity)
        return usuarios if usuarios.present?
    end    

    def self.usuarios_asesor
        usuarios = User.where("level = ?",2)
        return usuarios if usuarios.present?
    end    

    def self.label_name(dato)
        if dato == 0
            @nombre_usuario = 'Usuario no encontrado'
        else    
           @nombre_usuario = User.find(dato).name
        end   
        return @nombre_usuario
    end  

    def self.buscar_user(dato)
        @usu = User.find(dato)
        return @usu
    end  

    def self.label_license(dato)
        if dato == 0
            @license = 'no encontrada'
        else    
           @license = User.find(dato).license
        end   
        return @license
    end  


    def self.label_activity(dato)
        busqueda = CompanyPosition.find_by(id: dato.to_i)
        if busqueda.present?
            nombre = busqueda.name
        else
            nombre = 'No encontrada'
        end  
        return nombre
    end  

    def self.label_area_employee (dato)
        busqueda = CompanyArea.find_by(id: dato.to_i)
        if busqueda.present?
            nombre = busqueda.name
        else
            nombre = 'No encontrada'
        end    
        return nombre
    end  

    private
    def downcase_attributes
        self.username = username.downcase 
        self.email = email.downcase 
    end  

end
