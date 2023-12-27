class HistoryMatrixLegalItemsController < ApplicationController
    def index 
        if  Current.user && Current.user.level == 1
            @history_matrix_legal_items = HistoryMatrixLegalItem.all
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')      
        end           
    end  
    
    def new
      @history_matrix_legal_item = HistoryMatrixLegalItem.new  
    end    

    def create
        @history_matrix_legal_item = HistoryMatrixLegalItem.new(history_matrix_legal_item_params)

        if @history_matrix_legal_item.save then
            redirect_to history_matrix_legal_items_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @history_matrix_legal_item = HistoryMatrixLegalItem.find(params[:id])
    end
    
    def update
        @history_matrix_legal_item = HistoryMatrixLegalItem.find(params[:id])
        if @history_matrix_legal_item.update(history_matrix_legal_item_params)
            redirect_to history_matrix_legal_items_path, notice: 'Ciclo actualizado correctamente'
        else
            render :edit, history_matrix_legal_items: :unprocessable_entity
        end         
    end    

    def destroy
        @history_matrix_legal_item = HistoryMatrixLegalItem.find(params[:id])
        @history_matrix_legal_item.destroy
        redirect_to history_matrix_legal_items_path, notice: 'Item matriz borrado correctamente', history_matrix_legal_item: :see_other
    end    

    private

    def history_matrix_legal_item_params
        params.require(:history_matrix_legal_item).permit(:consecutive, :risk_factor, :issuing_entity,
        :requirement, :rule_name, :applicable_article, :apply, :evidence_compliance, 
        :responsible, :meets, :description_compliance, :history_matrix_legal_id, :attach_evidence )
    end    

end  

