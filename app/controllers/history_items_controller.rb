class HistoryItemsController < ApplicationController

    def index
        if  Current.user && Current.user.level == 1
            @history_items = HistoryItem.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end           
         
    end    

    def new 
      @history_item = HistoryItem.new  

    end    

    def create
        @history_item = HistoryItem.new(history_item_params)
        if @history_item.save then
            redirect_back fallback_location: root_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end     
    end    
 
    def edit
        @history_item = HistoryItem.find(params[:id])
    end
    
    def update
        
        @history_item = HistoryItem.find(params[:id])
        if @history_item.update(history_item_params)
            redirect_back fallback_location: root_path, notice: 'Item de la historia de la evaluación actualizada correctamente'
        else
            render :edit, history_items: :unprocessable_entity
        end         
    end    

    def destroy
        @history_item = HistoryItem.find(params[:id])
        @history_item.destroy
        redirect_back fallback_location: root_path, notice: 'Item de la historia de la evaluación borrada correctamente', history_item: :see_other
    end    

    private     
    def history_item_params
        params.require(:history_item).permit(:score, :description, :observation, :meets, :apply, 
        :cycle, :item_nro, :order_nro, :evaluation_rule_detail_id, :history_evaluation_id)
    end 

end 