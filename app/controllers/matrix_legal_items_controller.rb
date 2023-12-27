class MatrixLegalItemsController < ApplicationController
    def index 
        if  Current.user && Current.user.level == 1
            @matrix_legal_items = MatrixLegalItem.all
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')      
        end           
    end  
    
    def new
      @matrix_legal_item = MatrixLegalItem.new  
    end    

    def create
        @matrix_legal_item = MatrixLegalItem.new(matrix_legal_item_params)

        if @matrix_legal_item.save then
            redirect_back fallback_location: root_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @matrix_legal_item = MatrixLegalItem.find(params[:id])
    end
    
    def update
        @matrix_legal_item = MatrixLegalItem.find(params[:id])
        if @matrix_legal_item.update(matrix_legal_item_params)
            redirect_back fallback_location: root_path, notice: t('.created') 
        else
            render :edit, matrix_legals: :unprocessable_entity
        end         
    end    

    def destroy
        @matrix_legal_item = MatrixLegalItem.find(params[:id])
        @matrix_legal_item.destroy
        redirect_to matrix_legal_items_path, notice: 'Ciclo borrado correctamente', matrix_legal_item: :see_other
    end    

    private

    def matrix_legal_item_params
        params.require(:matrix_legal_item).permit(:consecutive, :risk_factor, :issuing_entity,
        :requirement, :rule_name, :applicable_article, :apply, :evidence_compliance, 
        :responsible, :meets, :description_compliance, :matrix_legal_id, :attach_evidence, :year )
    end  

end  

