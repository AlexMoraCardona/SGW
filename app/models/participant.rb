class Participant < ApplicationRecord
    belongs_to :user
    belongs_to :evidence

    def self.nombre(dato)
        @nombre = User.find(dato.to_i).name
        return  @nombre 
    end
end
