class HomesController < ApplicationController
    def index  
         @calendars =  Calendar.where("year = ? and month >= ?", Date.today.year, Date.today.month).order(:day) 
         @activities = Activity.where("state = ?",0).order(:citation) 
         @entity = Entity.find(Current.user.entity) if Current.user.entity > 0 
         @notificaciones = Calendar.notificaciones
         @cant_noti = @notificaciones.count if @notificaciones.present?
         
         @eval = Evaluation.where("entity_id = ?",@entity.id).last if @entity.present?
         @datos_generales = Evaluation.calculo_porcentaje_general(@eval)
         @puntaje_eva = @eval.score if @eval.present?
         @porcentaje_eva = @eval.percentage if @eval.present?
         @result_eva = @eval.result if @eval.present?
    end    

    def show
         
    end    
end  