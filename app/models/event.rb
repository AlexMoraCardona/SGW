class Event < ApplicationRecord
    belongs_to :entity
    belongs_to :user

    def self.labelsino(dato)
        if dato == 0 ; 'NO'
        elsif dato == 1 ; 'SI'
        end 
    end 

    def self.ransackable_attributes(auth_object = nil)
        ["date_new", "user_id", "entity_id", "work_accident", "mortal_accident", "occupational_disease",]
    end 

    def self.accidentes_mortales(entity)
        @accidentes_mortales = 0
        año = Time.now.year
        @events = Event.where("entity_id = ? ", entity.id) if entity.present?
        if @events.present?
            @events.each  do |event| 
                @accidentes_mortales += 1 if event.date_new.strftime("%Y").to_i == año && event.mortal_accident == 1   
            end
        end
    end    

    def self.accidentes_trabajo(entity)
        @accidentes_trabajo = 0
        año = Time.now.year
        @events = Event.where("entity_id = ? ", entity.id) if entity.present?
        if @events.present?
            @events.each  do |event| 
                @accidentes_trabajo += 1 if event.date_new.strftime("%Y").to_i == año  && event.work_accident == 1
            end
        end
    end    


end
