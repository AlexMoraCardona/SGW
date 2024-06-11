class ReportOfficialsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @report_officials = ReportOfficial.all.order(:month)
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end           
         
    end    

    def new
      @report_official = ReportOfficial.new  
    end    

    def create
        @report_official = ReportOfficial.new(report_official_params)
        if @report_official.save then
            redirect_to report_officials_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end   
    
    def actualizarindicadores 
        @report_official = ReportOfficial.find(params[:id])
        @events = Event.where("entity_id = ?", @report_official.entity_id)  
        @report_officials = ReportOfficial.where("entity_id = ? and year = ?", @report_official.entity_id, @report_official.year)
        @habil = BusinessDay.where("entity_id = ?", @report_official.entity_id)
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
            if rep.year == @report_official.year && rep.month <= @report_official.month then
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
                if event.work_accident == 1 && event.mortal_accident == 0  then
                    if  event.disability_start_date.month == @report_official.month && event.disability_start_date.year == @report_official.year then
                        if event.disability_end_date.month == @report_official.month && event.disability_end_date.year == @report_official.year then
                            eventsmontwork_accidentdays  +=  (event.disability_end_date.day - event.disability_start_date.day) + 1   
                        else
                            eventsmontwork_accidentdays  +=  (event.disability_start_date.end_of_month.day - event.disability_start_date.day) + 1
                        end   
                    else
                        if event.disability_end_date.month == @report_official.month && event.disability_end_date.year == @report_official.year then
                            eventsmontwork_accidentdays  +=  (event.disability_end_date.day - fechainicial.day) + 1
                        else
                            eventsmontwork_accidentdays += (fechafinal.day -   fechainicial.day) + 1
                        end
                    end  
                end 
            end
            #Proporcion de accidentes de trabajo mortales
            if event.work_accident == 1  then
                if  event.date_new.year == @report_official.year && event.date_new.month <= @report_official.month   then
                    eventsyearwork_accident += 1
                    if event.mortal_accident == 1 then
                        eventsyearmortal_accident += 1
                    end 
                end           
            end 
            #Prevalencia de la enfermedad laboral
            
            if event.occupational_disease == 1 && event.date_new.year <= @report_official.year then
                    total_occupational_disease += 1
            end 
            
            #Incidencia de la enfermedad laboral
            if event.occupational_disease == 1 && event.date_new.year == @report_official.year && event.date_new.month <= @report_official.month then
                total_occupational_disease_year += 1
            end 

            #Ausentismo   

            if event.disability_start_date <=  fechafinal && event.disability_end_date >= fechainicial  
                if event.laboral_inhability == 1 || event.common_inhability == 1  then
                    if  event.disability_start_date.month == @report_official.month && event.disability_start_date.year == @report_official.year then
                        if event.disability_end_date.month == @report_official.month && event.disability_end_date.year == @report_official.year then
                            fini = event.disability_start_date
                            ffin = event.disability_end_date
                            f = event.disability_start_date
                            while f <= ffin
                                no_esta = 0
                                if @habil.present? then
                                    @habil.each do |habil|
                                        if habil.date_skilled == f then
                                            no_esta = 1
                                        end  
                                    end
                                end   
                                if no_esta == 0 then     
                                    dias_ausentismo  += 1
                                end    
                                f += 1
                            end
                        else
                            fini = event.disability_start_date
                            ffin = event.disability_start_date.end_of_month
                            f = event.disability_start_date
                            while f <= ffin
                                no_esta = 0
                                if @habil.present? then
                                    @habil.each do |habil|
                                        if habil.date_skilled == f then
                                            no_esta = 1
                                        end  
                                    end 
                                end    
                                if no_esta == 0 then     
                                    dias_ausentismo  += 1
                                end    
                                f += 1
                            end
                        end   
                    else
                        if event.disability_end_date.month == @report_official.month && event.disability_end_date.year == @report_official.year then
                            fini = fechainicial
                            ffin = event.disability_end_date
                            f = fechainicial
                            while f <= ffin
                                no_esta = 0
                                if @habil.present? then
                                    @habil.each do |habil|
                                        if habil.date_skilled == f then
                                            no_esta = 1
                                        end  
                                    end 
                                end    
                                if no_esta == 0 then     
                                    dias_ausentismo  += 1
                                end    
                                f += 1
                            end
                        else
                            fini = fechainicial
                            ffin = fechafinal
                            f = fechainicial
                            while f <= ffin
                                no_esta = 0
                                if @habil.present? then
                                    @habil.each do |habil|
                                        if habil.date_skilled == f then
                                            no_esta = 1
                                        end  
                                    end 
                                end    
                                if no_esta == 0 then     
                                    dias_ausentismo  += 1
                                end    
                                f += 1
                            end
                        end
                    end  
                end 
            end

        end  
        
        @report_official.total_officials = total_officials 
        @report_official.frecuencia_accidentalidad = ((eventsmontwork_accident.to_f / total_officials.to_f) * 100).round(2) if total_officials > 0
        @report_official.total_work_accidents = eventsmontwork_accident
        @report_official.severidad_accidentalidad = ((eventsmontwork_accidentdays.to_f / total_officials.to_f) * 100).round(2) if total_officials  > 0
        @report_official.total_days_severidad_accidents = eventsmontwork_accidentdays  
        @report_official.proporcion_accidentes_mortales = ((eventsyearmortal_accident.to_f / eventsyearwork_accident.to_f) * 100).round(2) if eventsyearwork_accident > 0 
        @report_official.total_accidents_mortal_year = eventsyearmortal_accident
        @report_official.total_accidents_work_year = eventsyearwork_accident
        @report_official.total_occupational_disease = total_occupational_disease
        @report_official.promedio_year_officials = promedio
        @report_official.prevalencia_enfermedad_laboral = ((total_occupational_disease.to_f / promedio.to_f) * 100000).round(2) if promedio > 0  
        @report_official.total_occupational_disease_year = total_occupational_disease_year
        @report_official.incidencia_enfermedad_laboral = ((total_occupational_disease_year.to_f / promedio.to_f) * 100000).round(2) if promedio > 0  
        @report_official.total_days_absenteeism = dias_ausentismo 
        @report_official.ausentismo_causa_medica = ((dias_ausentismo.to_f / (@report_official.working_days_month.to_f * total_officials.to_f)) * 100000).round(2) if total_officials > 0  
        @report_official.save
        redirect_back fallback_location: root_path, notice: 'Reporte actualizado correctamente'
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
        params.require(:report_official).permit(:date, :number_oficial, :user_reports, :working_days_month, 
         :entity_id, :year, :month, :frecuencia_accidentalidad, :severidad_accidentalidad, 
         :proporcion_accidentes_mortales, :prevalencia_enfermedad_laboral, :incidencia_enfermedad_laboral, 
         :ausentismo_causa_medica, :number_oficial_independent, :number_oficial_student, :number_oficial_temporary, 
         :number_oficial_cooperative, :number_oficial_other, :total_officials, :total_work_accidents, :total_mortal_accident,
         :total_occupational_disease, :total_laboral_inhability, :total_common_inhability, :total_days_absenteeism, 
         :total_days_severidad_accidents, :total_accidents_mortal_year, :total_accidents_work_year,
         :promedio_year_officials, :total_occupational_disease_year)
    end 

end 


