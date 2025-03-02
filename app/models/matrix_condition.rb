class MatrixCondition < ApplicationRecord
    belongs_to :entity

    def self.name_user(user_id)
        name = 'No encontrado'
        user =  User.find(user_id)
        name = user.name
        return  name 
    end

    def self.label_firm(firm)
        if firm == 0 ; 'NO'
        elsif  firm == 1 ; 'SI'
        end 
    end  

    def self.total_actos_inseguros(entity)
        @matrix_condition = MatrixCondition.find_by(entity_id: entity.id) if entity.present?
        @matrix_unsafe_items = nil
        @matrix_unsafe_items = MatrixUnsafeItem.where("matrix_condition_id = ?", @matrix_condition.id) if @matrix_condition.present?
        @cantidad = 0
        @cantidad = @matrix_unsafe_items.count if @matrix_unsafe_items.present?
        @totalactos = 0

        if @cantidad > 0 then  
            @matrix_unsafe_items.each do |item|
                if item.clasification_unsafe == 1 
                    @totalactos += 1
                end    
            end    
        end  
        return @totalactos
    end

    def self.si_actos_inseguros(entity)
        @matrix_condition = MatrixCondition.find_by(entity_id: entity.id) if entity.present?
        @matrix_unsafe_items = nil
        @matrix_unsafe_items = MatrixUnsafeItem.where("matrix_condition_id = ?", @matrix_condition.id) if @matrix_condition.present?
        @cantidad = 0
        @cantidad = @matrix_unsafe_items.count if @matrix_unsafe_items.present?
        @totalactosinter = 0

        if @cantidad > 0 then  
            @matrix_unsafe_items.each do |item|
                if item.clasification_unsafe == 1 
                    @totalactosinter += 1 if item.state_unsafe == 1
                end    
            end    
        end  
        return @totalactosinter
    end

    def self.total_condiciones_inseguros(entity)
        @matrix_condition = MatrixCondition.find_by(entity_id: entity.id) if entity.present?
        @matrix_unsafe_items = nil
        @matrix_unsafe_items = MatrixUnsafeItem.where("matrix_condition_id = ?", @matrix_condition.id) if @matrix_condition.present?
        @cantidad = 0
        @cantidad = @matrix_unsafe_items.count if @matrix_unsafe_items.present?
        @totalcondiciones = 0

        if @cantidad > 0 then  
            @matrix_unsafe_items.each do |item|
                if item.clasification_unsafe == 0 
                    @totalcondiciones += 1
                end    
            end    
        end  
        return @totalcondiciones
    end

    def self.si_condiciones_inseguros(entity)
        @matrix_condition = MatrixCondition.find_by(entity_id: entity.id) if entity.present?
        @matrix_unsafe_items = nil
        @matrix_unsafe_items = MatrixUnsafeItem.where("matrix_condition_id = ?", @matrix_condition.id) if @matrix_condition.present?
        @cantidad = 0
        @cantidad = @matrix_unsafe_items.count if @matrix_unsafe_items.present?
        @totalcondicionesinter = 0

        if @cantidad > 0 then  
            @matrix_unsafe_items.each do |item|
                if item.clasification_unsafe == 0 
                    @totalcondicionesinter += 1 if item.state_unsafe == 1
                end    
            end    
        end  
        return  @totalcondicionesinter      
    end



    
    
end
