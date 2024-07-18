class TypeConditionInspectionsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @type_condition_inspections = TypeConditionInspection.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end           
    end    

    def new
      @type_condition_inspection = TypeConditionInspection.new  
    end    

    def create
        @type_condition_inspection = TypeConditionInspection.new(type_condition_inspection_params)

        if @type_condition_inspection.save then
            redirect_to type_condition_inspections_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @type_condition_inspection = TypeConditionInspection.find(params[:id])
    end
    
    def update
        @type_condition_inspection = TypeConditionInspection.find(params[:id])
        if @type_condition_inspection.update(type_condition_inspection_params)
            redirect_to type_condition_inspections_path, notice: 'Tipo de condición o situación actualizada correctamente'
        else
            render :edit, type_condition_inspections: :unprocessable_entity
        end         
    end    

    def destroy
        @type_condition_inspection = TypeConditionInspection.find(params[:id])
        @type_condition_inspection.destroy
        redirect_to type_condition_inspections_path, notice: 'Tipo de condición o situación borrada correctamente', type_condition_inspection: :see_other
    end    

    private

    def type_condition_inspection_params
        params.require(:type_condition_inspection).permit(:name)
    end 

end  