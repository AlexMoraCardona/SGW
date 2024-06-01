class HomesController < ApplicationController
    def index 
         @calendars =  Calendar.where("year = ? and month >= ?", Date.today.year, Date.today.month).order(:day) 
         @activities = Activity.all.order(:citation)
         @entity = Entity.find(Current.user.entity)
         calculo_porcentaje_general
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
            
            cumpli = "Estándares Cumplidos: " +  cumple.to_s
            pendi = "Estándares Pendientes: " + (total.to_i - cumple.to_i).to_s
            @datos_generales.push([cumpli, por.to_f]) if total.to_i > 0 
            @datos_generales.push([pendi, (100 - por.to_f)]) if total.to_i > 0 
    end 
    



    def show
         
    end    
end  