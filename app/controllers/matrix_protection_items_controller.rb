class MatrixProtectionItemsController < ApplicationController
    def index 
        if  Current.user && Current.user.level == 1
            @matrix_protection_items = MatrixProtectionItem.all
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')  
            session.delete(:user_id)    
        end           
    end  
    
    def new
      @matrix_protection_item = MatrixProtectionItem.new  
      @company_areas = CompanyArea.where("entity_id = ?",Current.user.entity.to_i) if Current.user.entity.present?
    end    

    def create
        @matrix_protection_item = MatrixProtectionItem.new(matrix_protection_item_params)
        @matrix_protection_item.areas =   @matrix_protection_item.areas.delete('"[]').to_s
        @matrix_protection_item.areas = @matrix_protection_item.areas.sub(",", " ").to_s
        if @matrix_protection_item.save then
            redirect_to crear_item_protection_matrix_protections_path(@matrix_protection_item.matrix_protection_id), notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @matrix_protection_item = MatrixProtectionItem.find(params[:id])
        @company_areas = CompanyArea.where("entity_id = ?",Current.user.entity.to_i) if Current.user.entity.present?
    end
    
    def update
        @matrix_protection_item = MatrixProtectionItem.find(params[:id])

        if @matrix_protection_item.update(matrix_protection_item_params)
            @matrix_protection_item.areas =   @matrix_protection_item.areas.delete('"[]').to_s
            @matrix_protection_item.areas = @matrix_protection_item.areas.sub(",", " ").to_s
            @matrix_protection_item.save
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
        params.require(:matrix_protection_item).permit(:num, :date_sheet, :delivery_format, :personal_induction, :state_protection, :durability, :matrix_protection_id, :protection_element_id, areas: [])
    end  

end  


