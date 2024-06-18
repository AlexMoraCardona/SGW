class MatrixActionItemsController < ApplicationController
    def index
         
    end    

    def new
      @matrix_action_item = MatrixActionItem.new  
    end    

    def create
        @matrix_action_item = MatrixActionItem.new(matrix_action_item_params)

        if @matrix_action_item.save then
            redirect_to matrix_corrective_actions_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @matrix_action_item = MatrixActionItem.find(params[:id])
        @locations  = Location.where("entity_id = ?", @matrix_action_item.matrix_corrective_action.entity_id) if @matrix_action_item.present?
        @template = Template.find(202)
        @entity = Entity.find(@matrix_action_item.matrix_corrective_action.entity_id) if @matrix_action_item.present?
    end
    
    def update
        @matrix_action_item = MatrixActionItem.find(params[:id])

        if @matrix_action_item.update(matrix_action_item_params)
            redirect_to matrix_corrective_actions_path, notice: 'Item actualizado correctamente'
        else
            render :edit, status: :unprocessable_entity
        end         
    end    

    def destroy
        @matrix_action_item = MatrixActionItem.find(params[:id])
        @matrix_action_item.destroy
        redirect_to matrix_corrective_actions_path, notice: 'Item borrado correctamente', matrix_action_item: :see_other
    end    

    private

    def matrix_action_item_params
        params.require(:matrix_action_item).permit(:consecutive, :year, :matrix_corrective_action_id, 
        :type_corrective, :clasification_type_corrective, :campus, :date_action_conformity, :area, 
         :description_action, :action_implement, :responsible, :commitment_date, :closet_date, 
         :took_actions, :state_actions, :origin_action )
    end 
end 






