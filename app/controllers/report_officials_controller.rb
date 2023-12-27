class ReportOfficialsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @report_officials = ReportOfficial.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end           
         
    end    

    def new
      @report_official = ReportOfficial.new  
    end    

    def create
        @report_official = ReportOfficial.new(report_official_params)
        rrr  
        if @report_official.save then
            redirect_to report_officials_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end   
    
    def actualizarindicadores 
        @report_official = ReportOfficial.find(params[:id])
        @events = Event.where("entity_id = ?", @report_official.entity_id)  
        @report_officials = ReportOfficial.where("entity_id = ?", @report_official.entity_id)
        eventsmontwork_accident = 0
        eventsmontwork_accidentdays = 0
        eventsyearmortal_accident = 0
        eventsyearwork_accident = 0
        fechainicial =  Date.new(@report_official.year,@report_official.month,01) 
        fechafinal = fechainicial.end_of_month
        total_officials = 0
        total_work_accidents = 0
        total_mortal_accident = 0
        total_occupational_disease = 0
        total_laboral_inhability = 0
        total_common_inhability = 0
        total_days_absenteeism = 0 
        total_occupational_disease_year = 0
        dias_ausentismo = 0

        #Total de funcionarios en el mes
        total_officials = (@report_official.number_oficial + @report_official.number_oficial_cooperative + @report_official.number_oficial_independent + @report_official.number_oficial_other + @report_official.number_oficial_student + @report_official.number_oficial_temporary)
        #Promedio de funcionarios por año
        total_meses = 0
        acumulado_funcionarios = 0
        promedio = 0
        @report_officials.each do |rep|
            if rep.year == @report_official.year then
               total_meses += 1  
               acumulado_funcionarios += (rep.number_oficial + rep.number_oficial_cooperative + rep.number_oficial_independent + rep.number_oficial_other + rep.number_oficial_student + rep.number_oficial_temporary)  
            end    
        end
        promedio = (acumulado_funcionarios / total_meses).round(2)    
        @events.each do |event|
            #Frecuencia de accidentalidad
            eventsmontwork_accident += 1 if (event.work_accident == 1 && event.date_new.month == @report_official.month && event.date_new.year == @report_official.year)   
            #Severidad de accidentalidad
            if event.disability_start_date <=  fechafinal && event.disability_end_date >= fechainicial  
                if event.work_accident == 1  then
                    if  event.disability_start_date.month == @report_official.month && event.disability_start_date.year == @report_official.year then
                        if event.disability_end_date.month == @report_official.month && event.disability_end_date.year == @report_official.year then
                            eventsmontwork_accidentdays  +=  (event.disability_end_date.day - event.disability_start_date.day)
                        else
                            eventsmontwork_accidentdays  +=  (event.disability_start_date.end_of_month.day - event.disability_start_date.day)
                        end   
                    else
                        if event.disability_end_date.month == @report_official.month && event.disability_end_date.year == @report_official.year then
                            eventsmontwork_accidentdays  +=  (event.disability_end_date.day - fechainicial.day)
                        else
                            eventsmontwork_accidentdays += fechafinal.day -   fechainicial.day
                        end
                    end  
                end 
            end
            #Proporcion de accidentes de trabajo mortales
            if event.work_accident == 1  then
                if  event.date_new.year == @report_official.year then
                    eventsyearwork_accident += 1
                    if event.mortal_accident then
                        eventsyearmortal_accident += 1
                    end 
                end           
            end 
            #Prevalencia de la enfermedad laboral
            
            if event.occupational_disease == 1 && event.date_new.year <= @report_official.year then
                    total_occupational_disease += 1
            end 
            
            #Incidencia de la enfermedad laboral
            if event.occupational_disease == 1 && event.date_new.year == @report_official.year then
                total_occupational_disease_year += 1
            end 

            #Ausentismo   
            dias_ausentismo += event.days_absenteeism if (event.date_new.month == @report_official.month && event.date_new.year == @report_official.year)   
        end  
        
        @report_official.total_officials = total_officials 
        @report_official.frecuencia_accidentalidad = ((eventsmontwork_accident / total_officials) * 100).round(2) if total_officials > 0
        @report_official.total_work_accidents = eventsmontwork_accident
        @report_official.severidad_accidentalidad = ((eventsmontwork_accidentdays / total_officials) * 100).round(2) if total_officials  > 0
        @report_official.total_days_severidad_accidents = eventsmontwork_accidentdays           
        @report_official.proporcion_accidentes_mortales = ((eventsyearmortal_accident / eventsyearwork_accident) * 100).round(2) if eventsyearwork_accident > 0 
        @report_official.total_accidents_mortal_year = eventsyearmortal_accident
        @report_official.total_accidents_work_year = eventsyearwork_accident
        @report_official.total_occupational_disease = total_occupational_disease
        @report_official.promedio_year_officials = promedio
        @report_official.prevalencia_enfermedad_laboral = ((total_occupational_disease / promedio) * 100000).round(2) if promedio > 0  
        @report_official.total_occupational_disease_year = total_occupational_disease_year
        @report_official.incidencia_enfermedad_laboral = ((total_occupational_disease_year / promedio) * 100000).round(2) if promedio > 0  
        @report_official.total_days_absenteeism = dias_ausentismo 
        @report_official.ausentismo_causa_medica = ((dias_ausentismo / (@report_official.working_days_month * total_officials)) * 100000).round(2) if total_officials > 0  
        
        if @report_official.update(report_official_params)
            redirect_to report_officials_path, notice: 'Indicadores actualizados correctamente'
        else
            render :edit, report_officials: :unprocessable_entity
        end         
 
    end    
 
    def edit
        @report_official = ReportOfficial.find(params[:id])
    end
    
    def update
        @report_official = ReportOfficial.find(params[:id])
        if @report_official.update(report_official_params)
            redirect_to report_officials_path, notice: 'Reporte actualizado correctamente'
        else
            render :edit, report_officials: :unprocessable_entity
        end         
    end    

    def destroy
        @report_official = ReportOfficial.find(params[:id])
        @report_official.destroy
        redirect_to report_officials_path, notice: 'Reporte borrado correctamente', report_official: :see_other
    end     

    private

    def report_official_params
        params.permit(:report_official).permit(:date, :number_oficial, :user_reports, :working_days_month, 
         :entity_id, :year, :month, :frecuencia_accidentalidad, :severidad_accidentalidad, 
         :proporcion_accidentes_mortales, :prevalencia_enfermedad_laboral, :incidencia_enfermedad_laboral, 
         :ausentismo_causa_medica, :number_oficial_independent, :number_oficial_student, :number_oficial_temporary, 
         :number_oficial_cooperative, :number_oficial_other, :total_officials, :total_work_accidents, :total_mortal_accident,
         :total_occupational_disease, :total_laboral_inhability, :total_common_inhability, :total_days_absenteeism, 
         :total_days_severidad_accidents, :total_accidents_mortal_year, :total_accidents_work_year,
         :promedio_year_officials, :total_occupational_disease_year)
    end 

end 
