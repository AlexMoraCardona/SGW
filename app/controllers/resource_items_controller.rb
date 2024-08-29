class ResourceItemsController < ApplicationController
    def index 
        if  Current.user && Current.user.level == 1
            @resource_items = ResourceItem.all
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')     
            session.delete(:user_id) 
        end           
    end  
    
    def new
      @resource_item = ResourceItem.new  
    end    

    def create
        @resource_item = ResourceItem.new(resource_item_params)

        if @resource_item.save then
            redirect_back fallback_location: root_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @resource_item = ResourceItem.find(params[:id])
    end
    
    def update
        @resource_item = ResourceItem.find(params[:id])
        if @resource_item.update(resource_item_params)
            redirect_to crear_item_resource_resources_path(@resource_item.resource_id), notice: t('.created')
        else
            render :edit, resources: :unprocessable_entity
        end         
    end    

    def destroy 
        @resource_item = ResourceItem.find(params[:id])
        @resource_item.destroy
        redirect_back fallback_location: root_path, notice: 'Recurso borrado correctamente', resource_item: :see_other
    end    

    private

    def resource_item_params
        params.require(:resource_item).permit(:consecutive, :process, :activity,
        :responsible, :value, :executed, :approved, :date_approved, :resource_id )
    end  

end  

