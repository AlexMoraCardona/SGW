class ReportOfficialsController < ApplicationController
    def index
        if  Current.user && Current.user.level > 0 && Current.user.level < 3
            @entity = Entity.find(Current.user.entity)
            @report_officials = ReportOfficial.where("entity_id = ?", @entity.id).order(id: :desc) if @entity.present?
        elsif Current.user && Current.user.level == 3 
            @entity = Entity.find(Current.user.entity)
            @report_officials = ReportOfficial.where("entity_id = ?",@entity.id).order(id: :desc)  if @entity.present?
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')    
            session.delete(:user_id)  
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
         :promedio_year_officials, :total_occupational_disease_year, :risk_danger_gestion, :risk_danger_total, 
         :risk_danger_ges, :per_training_coverage, :training_total, :training_ges, :per_scheduled_workers, 
         :scheduled_workers, :trained_workers, :per_autoevaluation, :items_autoevaluation_total, 
         :items_autoevaluation_cumple, :per_acpm, :acpm_total, :acpm_cumple, :compliance_legal, 
         :compliance_legal_total, :compliance_legal_cumple, :compliance_work_plan, :compliance_work_plan_total, 
         :compliance_work_plan_cumple, :per_activity_plan, :activity_plan_intervenida, :activity_plan_total, 
         :per_perfil_sociodemo, :perfil_sociodemo_total, :perfil_sociodemo_encuestados, :resources_allocated, 
         :resources_planned, :per_resources, :investigation_total, :investigation_investigated, :per_investigation)
    end 

end 
  