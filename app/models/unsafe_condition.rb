class UnsafeCondition < ApplicationRecord
    has_many_attached :evidencias
    belongs_to :entity

    def self.name_user(user_id)
        name = 'No encontrado'
        user =  User.find(user_id)
        name = user.name
        return  name 
    end 
    
    def self.evaluarcondicion(unsafe)
        @unsafe_condition = UnsafeCondition.find(unsafe.id)

        if @unsafe_condition.equipment_condition == 1 then 
            dato = 'Equipos en mal estado'
            crearcondicion(@unsafe_condition, dato)
        end    
        if @unsafe_condition.floors_condition == 1 then 
            dato = 'Pisos en mal estado'
            crearcondicion(@unsafe_condition, dato)
        end    
        if @unsafe_condition.not_demarcate_areas == 1 then 
            dato = 'No demarcar o asegurar áreas'
            crearcondicion(@unsafe_condition, dato)
        end    
        if @unsafe_condition.gases_dusts == 1 then 
            dato = 'Gases, polvos, Humos, vapores'
            crearcondicion(@unsafe_condition, dato)
        end    
        if @unsafe_condition.unsafe_work_design == 1 then 
            dato = 'Diseño de trabajo inseguros'
            crearcondicion(@unsafe_condition, dato)
        end    
        if @unsafe_condition.inadequate_signage == 1 then 
            dato = 'Señalizaciones inadecuadas o insuficientes'
            crearcondicion(@unsafe_condition, dato)
        end    
        if @unsafe_condition.defective_tools == 1 then 
            dato = 'Herramientas defectuosas'
            crearcondicion(@unsafe_condition, dato)
        end    
        if @unsafe_condition.lack_alarm == 1 then 
            dato = 'Carencia de sistemas de alarma'
            crearcondicion(@unsafe_condition, dato)
        end    
        if @unsafe_condition.lack_cleanliness == 1 then 
            dato = 'Falta de orden y aseo'
            crearcondicion(@unsafe_condition, dato)
        end    
        if @unsafe_condition.lack_space_work == 1 then 
            dato = 'Escasez de espacio para trabajar'
            crearcondicion(@unsafe_condition, dato)
        end    
        if @unsafe_condition.incorrect_storage == 1 then 
            dato = 'Almacenamiento incorrecto'
            crearcondicion(@unsafe_condition, dato)
        end    
        if @unsafe_condition.excessive_noise_levels == 1 then 
            dato = 'Niveles de ruido excesivo'
            crearcondicion(@unsafe_condition, dato)
        end    
        if @unsafe_condition.inadequate_lighting_ventilation == 1 then 
            dato = 'Iluminación o ventilación inadecuada'
            crearcondicion(@unsafe_condition, dato)
        end    
        if  @unsafe_condition.other_unsafe_conditions.blank? == false then 
            dato = @unsafe_condition.other_unsafe_conditions
            crearcondicion(@unsafe_condition, dato)
        end    
        if @unsafe_condition.not_using_equipment == 1 then 
            dato = 'No usar el equipo de Protección personal'
            crearcondicion(@unsafe_condition, dato)
        end    
        if @unsafe_condition.operating_without_authorization == 1 then 
            dato = 'Operar sin autorización equipo'
            crearcondicion(@unsafe_condition, dato)
        end    
        if @unsafe_condition.running_facilities == 1 then 
            dato = 'Correr por las instalaciones'
            crearcondicion(@unsafe_condition, dato)
        end    
        if @unsafe_condition.using_defective_tool == 1 then 
            dato = 'Usar equipo/herramienta defectuosa'
            crearcondicion(@unsafe_condition, dato)
        end    
        if @unsafe_condition.psychoactive_substances == 1 then 
            dato = 'Trabajar bajo el efecto de sustancias psicoactivas o alcohol'
            crearcondicion(@unsafe_condition, dato)
        end    
        if @unsafe_condition.ignore_dangerous == 1 then 
            dato = 'Ignorar las condiciones de peligro'
            crearcondicion(@unsafe_condition, dato)
        end    
        if @unsafe_condition.use_wrong_tool == 1 then 
            dato = 'Usar el equipo/herramienta incorrecto'
            crearcondicion(@unsafe_condition, dato)
        end    
        if @unsafe_condition.wrong_position == 1 then 
            dato = 'Adoptar una posición incorrecta'
            crearcondicion(@unsafe_condition, dato)
        end    
        if @unsafe_condition.heights_without_authorization == 1 then 
            dato = 'Trabajar en alturas sin autorización'
            crearcondicion(@unsafe_condition, dato)
        end    
        if @unsafe_condition.workplace_distractions == 1 then 
            dato = 'Crear distracciones en el sitio de trabajo'
            crearcondicion(@unsafe_condition, dato)
        end    
        if @unsafe_condition.gen_on_desk == 1 then 
            dato = 'Subirse sobre escritorios, sillas (etc)'
            crearcondicion(@unsafe_condition, dato)
        end 
        if  @unsafe_condition.other_features.blank? == false then 
            dato = @unsafe_condition.other_features
            crearcondicion(@unsafe_condition, dato)
        end    


    end   
    
    def self.crearcondicion(unsafe_condition, dato) 
        @unsafe_condition = UnsafeCondition.find(unsafe_condition.id)
        @user = User.find(@unsafe_condition.user_reports) if @unsafe_condition.present?
        @entity = Entity.find(@unsafe_condition.entity_id)
        @asesor = User.find(@entity.responsible_sst) if @entity.responsible_sst > 0 
        @asesor = User.find(@entity.external_consultant) if @entity.external_consultant > 0 
        @representante_legal = User.find_by(nro_document: @entity.document_number_legal_representative) if @entity.present?
        
        @matrix_condition = MatrixCondition.find_by(entity_id: @entity.id) if @entity.present?
        if @matrix_condition == nil then
            @matrix_condition = MatrixCondition.new
            @matrix_condition.date_unsafe = Time.now
            @matrix_condition.user_representante = @representante_legal.id if @representante_legal.present?
            @matrix_condition.user_responsible = @asesor.id
            @matrix_condition.entity_id = @entity.id
            @matrix_condition.save
        end   

        @matrix_unsafe_item = MatrixUnsafeItem.new
        @matrix_unsafe_item.date_item = Time.now
        @matrix_unsafe_item.user_reporta = @user.id if @user.present?
        @matrix_unsafe_item.cargo_reporta = @user.activity if @user.present?
        @matrix_unsafe_item.correo_reporta = @user.email if @user.present?
        @matrix_unsafe_item.sede = @unsafe_condition.place_report if @unsafe_condition.present?
        @matrix_unsafe_item.exact_ubication = @unsafe_condition.exact_ubication if @unsafe_condition.present?
        @matrix_unsafe_item.description_usafe = dato
        @matrix_unsafe_item.solution_usafe = @unsafe_condition.alternative_soluctions if @unsafe_condition.present?
        @matrix_unsafe_item.tip_action = 0
        @matrix_unsafe_item.state_unsafe = 0
        @matrix_unsafe_item.user_recibe = @asesor.id if @asesor.present?
        @matrix_unsafe_item.entity_id = @entity.id if @entity.present?
        @matrix_unsafe_item.unsafe_condition_id = @unsafe_condition.id if @unsafe_condition.present?
        @matrix_unsafe_item.matrix_condition_id = @matrix_condition.id if @matrix_condition.present?
        @matrix_unsafe_item.save
    end


end
