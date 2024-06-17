class MatrixUnsafeItemsController < ApplicationController
    def index
         
    end    

    def new
      @matrix_unsafe_item = MatrixUnsafeItem.new  
    end    

    def create
        @matrix_unsafe_item = MatrixUnsafeItem.new(matrix_unsafe_item_params)

        if @matrix_unsafe_item.save then
            redirect_to matrix_condition_path(@matrix_unsafe_item.matrix_condition_id), notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @matrix_unsafe_item = MatrixUnsafeItem.find(params[:id])
    end
    
    def update
        @matrix_unsafe_item = MatrixUnsafeItem.find(params[:id])

        if @matrix_unsafe_item.update(matrix_unsafe_item_params)
            redirect_back fallback_location: root_path, notice: 'Item actualizado correctamente'
        else
            render :edit, status: :unprocessable_entity
        end         
    end    

    def destroy
        @matrix_unsafe_item = MatrixUnsafeItem.find(params[:id])
        @matrix_unsafe_item.destroy
        redirect_back fallback_location: root_path, notice: 'Item borrado correctamente', matrix_unsafe_item: :see_other
    end    

    private

    def matrix_unsafe_item_params
        params.require(:matrix_unsafe_item).permit(:date_item, :user_reporta, :cargo_reporta, :correo_reporta, :sede, :exact_ubication, :description_usafe, :solution_usafe, :tip_action, :state_unsafe, :observations, :user_recibe, :date_intervencion, :entity_id, :unsafe_condition_id, :matrix_condition_id, registros: [])
    end 

end 

