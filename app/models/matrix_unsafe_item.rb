class MatrixUnsafeItem < ApplicationRecord
    belongs_to :entity
    belongs_to :matrix_condition
    belongs_to :unsafe_condition
    has_many_attached :registros

    def self.name_user(user_id)
        name = 'No encontrado'
        user =  User.find(user_id)
        name = user.name
        return  name 
    end

    def self.tipo_accion(dato)
        if dato == 0 ; 'Preventiva'
        elsif  dato == 1 ; 'Correctiva'
        elsif  dato == 2 ; 'Mejora'
        end 
    end

    def self.clasificacion_accion(dato)
        if dato == 0 ; 'Condición'
        elsif  dato == 1 ; 'Acto'
        end 
    end    

    def self.estado(dato)
        if dato == 0 ; 'Abierta'
        elsif  dato == 1 ; 'Cerrada'
        end 
    end


end
