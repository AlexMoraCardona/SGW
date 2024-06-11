class HomesController < ApplicationController
    def index 
         @calendars =  Calendar.where("year = ? and month >= ?", Date.today.year, Date.today.month).order(:day) 
         @activities = Activity.all.order(:citation)
         @entity = Entity.find(Current.user.entity)
         calculo_porcentaje_general
         calculo_sex
         calculo_clasificacion_cargo
         accidentes_mortales
    end    


    def calculo_porcentaje_general
            eval = Evaluation.where("entity_id = ?",@entity.id).last if @entity.present?
            details = EvaluationRuleDetail.where("evaluation_id = ? and apply = ?", eval.id, 1)
            total = 0
            cumple = 0
            por = 0.0
            @datos_generales = []
            details.each do |d|
                total += 1
                cumple += 1 if d.meets > 0 
                    
            end
            por = ((cumple.to_f / total.to_f) * 100).round(2).to_f if total.to_f > 0
            
            cumpli = "Cumplidos: " +  cumple.to_s
            pendi = "Pendientes: " + (total.to_i - cumple.to_i).to_s
            @datos_generales.push([cumpli, por.to_f]) if total.to_i > 0 
            @datos_generales.push([pendi, (100 - por.to_f)]) if total.to_i > 0 
    end 
    
    def calculo_sex
        users = User.where("entity = ? and state = ?", @entity.id, 1).order(:sex) if @entity.present?
        total = 0
        @datos_sex = []
        users.group_by(&:sex).each  do |niv, det|
            cant = 0
            det.each do |d|
               total += 1 
               cant += 1 
            end  
            hom = "Hombres: " +  cant.to_s  if  niv.to_i == 0
            muj = "Mujeres: " + cant.to_s if  niv.to_i == 1
            @datos_sex.push([hom, cant]) if  niv.to_i == 0
            @datos_sex.push([muj, cant]) if  niv.to_i == 1
        end
    end     

    def calculo_clasificacion_cargo
        users = User.where("entity = ? and state = ?", @entity.id, 1).order(:clasification_post) if @entity.present?
        @total_colaboradores = 0
        @datos_clasificacion_cargo = []
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

    def accidentes_mortales
        @accidentes_mortales = 0
        @accidentes_trabajo = 0
        año = Time.now.year
        @entity = Entity.find(Current.user.entity)
        @events = Event.where("entity_id = ? ", @entity.id)
        if @events.present?
            @events.each  do |event| 
                @accidentes_mortales += 1 if event.date_new.strftime("%Y").to_i == año && event.mortal_accident == 1   
                @accidentes_trabajo += 1 if event.date_new.strftime("%Y").to_i == año  && event.work_accident == 1
            end
        end
    end    



    def show
         
    end    
end  