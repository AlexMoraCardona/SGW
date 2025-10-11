class MatrixActionItemsController < ApplicationController
    def index
         
    end    

    def new
      @matrix_action_item = MatrixActionItem.new  
    end    

    def create
        @matrix_action_item = MatrixActionItem.new(matrix_action_item_params)
        @matrix_corrective_action = MatrixCorrectiveAction.find(@matrix_action_item.matrix_corrective_action_id) if @matrix_action_item.present?
        @matrix_action_items = MatrixActionItem.where("matrix_corrective_action_id = ?", @matrix_action_item.matrix_corrective_action_id) if @matrix_action_item.present?

        if @matrix_action_items.present?
            @matrix_action_item.clasification_type_corrective = "AP" +   (@matrix_action_items.where("type_corrective = ?", 0).count + 1).to_s if @matrix_action_item.type_corrective == 0  
            @matrix_action_item.clasification_type_corrective = "AM" +   (@matrix_action_items.where("type_corrective = ?", 1).count + 1).to_s if @matrix_action_item.type_corrective == 1  
            @matrix_action_item.clasification_type_corrective = "AC" +   (@matrix_action_items.where("type_corrective = ?", 2).count + 1).to_s if @matrix_action_item.type_corrective == 2  
        else
            @matrix_action_item.clasification_type_corrective = "AP1" if @matrix_action_item.type_corrective == 0  
            @matrix_action_item.clasification_type_corrective = "AM1" if @matrix_action_item.type_corrective == 1  
            @matrix_action_item.clasification_type_corrective = "AC1" if @matrix_action_item.type_corrective == 2  
        end

        if @matrix_action_item.save then
            redirect_to matrix_corrective_actions_path(entity_id: @matrix_corrective_action.entity_id), notice: 'Por favor diligencie el nuevo formulario'

        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @matrix_action_item = MatrixActionItem.find(params[:id])
        @locations  = Location.where("entity_id = ?", @matrix_action_item.matrix_corrective_action.entity_id) if @matrix_action_item.present?
        @template = Template.where("format_number = ? and document_vigente = ?",67,1).last  
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
         :took_actions, :state_actions, :origin_action, :hallazgo)
    end 
end 






