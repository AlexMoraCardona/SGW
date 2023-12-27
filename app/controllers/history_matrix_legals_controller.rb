class HistoryMatrixLegalsController < ApplicationController
    def index 
        if  Current.user && Current.user.level == 1
            @history_matrix_legals = HistoryMatrixLegal.all
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')      
        end           
    end  
    
    def new
      @history_matrix_legal = HistoryMatrixLegal.new  
    end    

    def create
        @history_matrix_legal = HistoryMatrixLegal.new(history_matrix_legal_params)

        if @history_matrix_legal.save then
            redirect_to history_matrix_legals_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @history_matrix_legal = HistoryMatrixLegal.find(params[:id])
    end
    
    def update
        @history_matrix_legal = HistoryMatrixLegal.find(params[:id])
        if @history_matrix_legal.update(history_matrix_legal_params)
            redirect_to history_matrix_legals_path, notice: 'Historia matriz actualizada correctamente'
        else
            render :edit, history_matrix_legals: :unprocessable_entity
        end         
    end    

    def destroy
        @history_matrix_legal = HistoryMatrixLegal.find(params[:id])
        @history_matrix_legal.destroy
        redirect_to history_matrix_legals_path, notice: 'Historia matriz borrada correctamente', history_matrix_legal: :see_other
    end    

    private

    def history_matrix_legal_params
        params.require(:history_matrix_legal).permit(:date_create, :user_legal_representative, :user_adviser_sst, 
        :user_responsible_sst, :matrix_legal_id, :entity_id, :meets_compliment, :meets_partial, :meets_earring )
    end  

end  
