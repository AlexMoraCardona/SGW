class MatrixDangerRisk < ApplicationRecord
    belongs_to :entity
    has_many :matrix_danger_items
    
    def name_user(user_id)
        name = 'No encontrado'
        user =  User.find(user_id)
        name = user.name
        return  name 
    end

    def self.resumen(items)
        @total_items = 0
        @no = 0
        @parcial = 0
        @si = 0
        items.each do |item| 
            @total_items += 1 
            if item.meets.to_i == 0 ; @no += 1
            elsif item.meets.to_i == 1 ; @parcial += 1
            elsif item.meets.to_i == 2 ; @si += 1
            end
        end 
        return @total_items
    end     

    def label_firm(firm)
        if firm == 0 ; 'NO'
        elsif  firm == 1 ; 'SI'
        end 
    end  

end
