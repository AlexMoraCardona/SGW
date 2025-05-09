class MatrixDangerItemsController < ApplicationController
    def index
         
    end    

    def new
      @matrix_danger_item = MatrixDangerItem.new  
    end    

    def create
        @matrix_danger_item = MatrixDangerItem.new(matrix_danger_item_params)
        @matrix_danger_item.clasification_danger_id = ClasificationDangerDetail.find(@matrix_danger_item.clasification_danger_detail_id).clasification_danger_id if @matrix_danger_item.clasification_danger_detail_id.present? 

        if @matrix_danger_item.save then
            MatrixDangerItem.calculos(@matrix_danger_item.id) if @matrix_danger_item.present?
            redirect_back fallback_location: root_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @matrix_danger_item = MatrixDangerItem.find(params[:id])
    end
    
    def update
        @matrix_danger_item = MatrixDangerItem.find(params[:id])

        @matrix_danger_item.clasification_danger_id = ClasificationDangerDetail.find(@matrix_danger_item.clasification_danger_detail_id).clasification_danger_id if @matrix_danger_item.clasification_danger_detail_id.present? 
        if @matrix_danger_item.update(matrix_danger_item_params)
            MatrixDangerItem.calculos(@matrix_danger_item.id) if @matrix_danger_item.present?
            redirect_to matrix_danger_risks_path(entity_id: @matrix_danger_item.matrix_danger_risk.entity_id), notice: 'Item actualizado correctamente'
        else
            render :edit, status: :unprocessable_entity
        end         
    end    

    def destroy
        @matrix_danger_item = MatrixDangerItem.find(params[:id])
        @matrix_danger_item.destroy
        redirect_to matrix_danger_risks_path(entity_id: @matrix_danger_item.matrix_danger_risk.entity_id), notice: 'Item borrado correctamente', matrix_danger_item: :see_other
    end    

    private

    def matrix_danger_item_params
        params.require(:matrix_danger_item).permit(:consecutive, :year, :source_information, :activity, :task, :type_task, :origin, :possible_effects_health, 
        :possible_effects_security, :description_existing_control_origin, :description_existing_control_medium, 
        :description_existing_control_person, :description_existing_control_observations, 
        :deficiency_level, :exposure_level, :probability_level, :interpretation, :consequence_level, 
        :level_risk_intervention, :risk_level_interpretation, :risk_acceptability, :number_exposed, 
        :hours_exposure, :worst_consequence, :existence_legal_requirement, :intervention_measures_elimination, 
        :intervention_measures_replacement, :intervention_measures_engineering_control, 
        :intervention_measures_acsw, :intervention_measures_ppee, :responsible_implementation, 
        :type_register, :proposed_date, :implementation_date, :follow_date, :observations, :clasification_danger_id, 
        :clasification_danger_detail_id, :matrix_danger_risk_id, :location_id, :number_exposed_contrators, :number_exposed_totals, :danger_intervened)
    end 

end 


