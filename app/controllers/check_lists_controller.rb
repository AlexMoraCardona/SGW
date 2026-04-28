class CheckListsController < ApplicationController
    def index

        if  Current.user
            @check_lists = CheckList.all
            @lists =  List.all
            @lists = @lists.all.uniq { |a| a.numero }
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')  
             session.delete(:user_id)    
         end          
    end    

    def new
      @check_list = CheckList.new  
    end    

    def create
        @check_list = CheckList.new(check_list_params)

        if @check_list.save then
            redirect_to fallback_location: root_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @check_list = CheckList.find(params[:id])
        @check_list_items = CheckListItem.where("check_list_id = ?",@check_list.id) if @check_list.present?
    end
    
    def update 
        @check_list = CheckList.find(params[:id])
        if @check_list.update(check_list_params)
            redirect_to check_lists_path, notice: 'Lista actualizada correctamente'
        else
            render :edit, check_lists: :unprocessable_entity
        end         
    end    

    def destroy
        @check_list = CheckList.find(params[:id])
        @check_list.destroy
        redirect_to check_lists_path, notice: 'Lista borrada correctamente', check_list: :see_other
    end    

    private

    def check_list_params
        params.require(:check_list).permit(:name, :state)
    end 

end  
