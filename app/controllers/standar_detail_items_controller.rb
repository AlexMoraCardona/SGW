class StandarDetailItemsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @standar_detail_items = StandarDetailItem.where("aplica = ?", 1).order(:order_nro).decorate
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')  
             session.delete(:user_id)    
         end             
    end     

    def new
      @standar_detail_item = StandarDetailItem.new  
    end    

    def create
        @standar_detail_item = StandarDetailItem.new(standar_detail_item_params)

        if @standar_detail_item.save then
            redirect_to standar_detail_items_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @standar_detail_item = StandarDetailItem.find(params[:id])
    end
    
    def update
        @standar_detail_item = StandarDetailItem.find(params[:id])
        if @standar_detail_item.update(standar_detail_item_params)
            redirect_to standar_detail_items_path, notice: 'Item actualizado correctamente'
        else
            render :edit, standar_detail_items: :unprocessable_entity
        end         
    end    

    def destroy
        @standar_detail_item = StandarDetailItem.find(params[:id])
        @standar_detail_item.destroy
        redirect_to standar_detail_items_path, notice: 'Item borrado correctamente', standar_detail_item: :see_other
    end     

    private

    def standar_detail_item_params
        params.require(:standar_detail_item).permit(:description, :maximun_value, :standar_detail_id, :aplica, :item_nro, :order_nro, :criterion, :verification_mode)
    end 

end  

