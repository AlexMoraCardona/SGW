class CheckListItemsController < ApplicationController
    def index

        if  Current.user
            @check_list = CheckList.find(params[:id])
            @check_list_items = CheckListItem.where("check_list_id = ?",@check_list.id) if @check_list.present?
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')  
             session.delete(:user_id)    
         end          
         
    end    

    def new
      @check_list = CheckList.find(params[:format])   
      @check_list_item = CheckListItem.new  
    end    

    def create
        @check_list_item = CheckListItem.new(check_list_item_params)

        if @check_list_item.save then
            redirect_to check_lists_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @check_list_item = CheckListItem.find(params[:id])
        @check_list = CheckList.find(@check_list_item.check_list_id) if @check_list_item.present?
    end
    
    def update 
        @check_list_item = CheckListItem.find(params[:id])
        if @check_list_item.update(check_list_item_params)
            redirect_to edit_check_list_path(@check_list_item.check_list_id), notice: 'Item actualizado correctamente'
        else
            render :edit, edit_check_list_path(@check_list_item.check_list_id), notice: :unprocessable_entity
        end         
    end    

    def destroy
        @check_list_item = CheckListItem.find(params[:id])
        @check_list_item.destroy
        redirect_to edit_check_list_path(@check_list_item.check_list_id), notice: 'Item borrado correctamente', check_list_item: :see_other
    end    

    private

    def check_list_item_params
        params.require(:check_list_item).permit(:name, :clasification, :state, :item, :check_list_id)
    end 

end  
