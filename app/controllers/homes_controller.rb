class HomesController < ApplicationController
    def index  
         @calendars =  Calendar.where("year = ? and month >= ?", Date.today.year, Date.today.month).order(:day) 
         @activities = Activity.all.order(:citation)
         @entity = Entity.find(Current.user.entity) if Current.user.entity > 0 
         @notificaciones = Calendar.notificaciones
         @cant_noti = @notificaciones.count if @notificaciones.present?
         
         @eval = Evaluation.where("entity_id = ?",@entity.id).last if @entity.present?
         @datos_generales = Evaluation.calculo_porcentaje_general(@eval)
         @puntaje_eva = @eval.score if @eval.present?
         @porcentaje_eva = @eval.percentage if @eval.present?
         @result_eva = @eval.result if @eval.present?
 
         @datos_sex = User.calculo_sex(@entity)
         @datos_clasificacion_cargo = User.calculo_clasificacion_cargo(@entity)
         @accidentes_mortales = Event.accidentes_mortales(@entity)
         @accidentes_trabajo = Event.accidentes_trabajo(@entity)
         @dias_incapacidad_accidentes = ReportOfficial.dias_incapacidad_accidentes(@entity)
         @enfermedad_laboral = ReportOfficial.enfermedad_laboral(@entity)
         @dias_comun_laboral = ReportOfficial.dias_comun_laboral(@entity)
         @totalactos = MatrixCondition.total_actos_inseguros(@entity)
         @totalactosinter = MatrixCondition.si_actos_inseguros(@entity)
         @totalcondiciones = MatrixCondition.total_condiciones_inseguros(@entity)
         @totalcondicionesinter = MatrixCondition.si_condiciones_inseguros(@entity)
         @totalpeligros = MatrixDangerRisk.total_peligros_riesgos(@entity)
         @totalpeligrosinter = MatrixDangerRisk.inter_peligros_riesgos(@entity)
         @datos_capacitacion = Training.capacitaciones(@entity)

    end    

    def show
         
    end    
end  