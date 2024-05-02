class ProvidesProtectionItemsController < ApplicationController
    def index 
        if  Current.user && Current.user.level == 1
            @provides_protection_items = ProvidesProtectionItem.all
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')      
        end           
    end  
    
    def new
      @provides_protection_item = ProvidesProtectionItem.new  
    end    

    def create
        @provides_protection_item = ProvidesProtectionItem.new(provides_protection_item_params)

        if @provides_protection_item.save then
            redirect_back fallback_location: root_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @provides_protection_item = ProvidesProtectionItem.find(params[:id])
    end
    
    def update
        @provides_protection_item = ProvidesProtectionItem.find(params[:id])
        if @provides_protection_item.update(provides_protection_item_params)
            redirect_to crear_item_provide_provides_protections_path(@provides_protection_item.provides_protection_id), notice: t('.created')
        else
            render :edit, provides_protections: :unprocessable_entity
        end         
    end    

    def destroy
        @provides_protection_item = ProvidesProtectionItem.find(params[:id])
        @provides_protection_item.destroy
        redirect_to crear_item_provide_provides_protections_path(@provides_protection_item.provides_protection_id), notice: 'Item borrado correctamente', provides_protection_item: :see_other
    end    

    private

    def provides_protection_item_params
        params.require(:provides_protection_item).permit(:cant, :date_entrega, :num, :provides_protection_id, :protection_element_id)
    end  

end  







