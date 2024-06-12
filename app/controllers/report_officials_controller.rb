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

    def actualizar_indicadores
        ReportOfficial.actuali_indicadores(params[:id])
        redirect_back fallback_location: root_path, notice: 'Reporte actualizado correctamente'

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


