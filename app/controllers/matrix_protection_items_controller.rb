class MatrixProtectionItemsController < ApplicationController
    def index 
        if  Current.user && Current.user.level == 1
            @matrix_protection_items = MatrixProtectionItem.all
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')      
        end           
    end  
    
    def new
      @matrix_protection_item = MatrixProtectionItem.new  
    end    

    def create
        @matrix_protection_item = MatrixProtectionItem.new(matrix_protection_item_params)

        if @matrix_protection_item.save then
            redirect_back fallback_location: root_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @matrix_protection_item = MatrixProtectionItem.find(params[:id])
    end
    
    def update
        @matrix_protection_item = MatrixProtectionItem.find(params[:id])
        if @matrix_protection_item.update(matrix_protection_item_params)
            redirect_to crear_item_protection_matrix_protections_path(@matrix_protection_item.matrix_protection_id), notice: t('.created')
        else
            render :edit, matrix_protections: :unprocessable_entity
        end         
    end    

    def destroy
        @matrix_protection_item = MatrixProtectionItem.find(params[:id])
        @matrix_protection_item.destroy
        redirect_to crear_item_protection_matrix_protections_path(@matrix_protection_item.matrix_protection_id), notice: 'Item borrado correctamente', matrix_protection_item: :see_other
    end    

    private

    def matrix_protection_item_params
        params.require(:matrix_protection_item).permit(:num, :durability, :date_sheet, :delivery_format, :personal_induction, :state_protection, :matrix_protection_id, :protection_element_id)
    end  

end  


