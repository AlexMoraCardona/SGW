class EvidencesController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @evidences = Evidence.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')   
             session.delete(:user_id)   
         end           
         
    end    

    def new
      @evidence = Evidence.new  
    end    

    def create
        @evidence = Evidence.new(evidence_params)

        if @evidence.save then
            redirect_to evidences_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @evidence = Evidence.find(params[:id])
    end
    
    def update
        @evidence = Evidence.find(params[:id])
        if @evidence.update(evidence_params)
            redirect_to edit_evaluation_rule_detail_path(@evidence.evaluation_rule_detail_id), notice: 'Evidencia actualizada correctamente'
        else
            render :edit, evidences: :unprocessable_entity
        end         
    end    

    def destroy
        @evidence = Evidence.find(params[:id])
        @evidence.destroy
        redirect_to evidences_path, notice: 'Evidencia borrada correctamente', evidence: :see_other
    end    

    private

    def evidence_params
        params.require(:evidence).permit(:date, :date_update, :place, :goals, :number_attendees, 
        :number_officials, :period, :entity_id, :template_id, :evaluacion_rule_detail_id, :letter_value,
         :value, :string, :initial_period, :final_period, :initial_time, :final_time, :vigia, :year_initial, :year_final, 
         :month_initial, :month_final, :total_votes, :description_complaint, :data, :evidence_authority, :object, :policy, 
         :compliances, :por_cobertura, :por_trabajadores, :por_reacciones, :por_aprendizaje, :por_resultados, :direct_exposure_areas, :medical_examination_entity, :biologica_risk_area)
    end 

end   

