class ChangeManagementItemsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @change_management_items = ChangeManagementItem.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')    
             session.delete(:user_id)  
         end           
         
    end    

    def new
      @change_management_item = ChangeManagementItem.new  
      @company_areas = CompanyArea.where("entity_id = ?",Current.user.entity.to_i) if Current.user.entity.present?
    end    

    def create
        @change_management_item = ChangeManagementItem.new(change_management_item_params)

        if @change_management_item.save then
            redirect_to change_management_path(@change_management_item.change_management_id), notice: 'Creado correctamente' 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @change_management_item = ChangeManagementItem.find(params[:id])
    end
    
    def update
        @change_management_item = ChangeManagementItem.find(params[:id])
 
        if @change_management_item.update(change_management_item_params)
            redirect_to change_management_path(@change_management_item.change_management_id), notice: 'Actualizado correctamente'
        else
            render :edit, change_management_items: :unprocessable_entity
        end         
    end    

    def destroy
        @change_management_item = ChangeManagementItem.find(params[:id])
        @change_management_item.destroy
        redirect_to change_management_path(@change_management_item.change_management_id), notice: 'Investigador borrado correctamente', change_management_item: :see_other
    end  
    

    private

    def change_management_item_params
        params.require(:change_management_item).permit(:activity_plannig, :responsible_planning, 
        :communicate_change, :date_execution, :date_continue, :change_management_id)
    end 

end  
 


      