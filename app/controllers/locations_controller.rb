class LocationsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @locations = Location.all 
        else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
             session.delete(:user_id)
         end           
    end    

    def new
      @location = Location.new  
    end    

    def create
        @location = Location.new(location_params)

        if @location.save then
            redirect_to entities_path, notice: t('.created')  
        else
            render :new, locations: :unprocessable_entity
        end    
    end    
 
    def edit
        @location = Location.find(params[:id])
    end
    
    def update
        @location = Location.find(params[:id])
        if @location.update(location_params)
            redirect_to entities_path, notice: 'Sede actualizada correctamente'
        else
            render :edit, status: :unprocessable_entity
        end         
    end    

    def destroy
        @location = Location.find(params[:id])
        @location.destroy
        redirect_to locations_path, notice: 'Sede borrada correctamente', location: :see_other
    end    

    private

    def location_params
        params.require(:location).permit(:phone_number_entity, :cell_entity, :entity_address, 
        :entity_location_code, :entity_zone,  :number_workers, :name_locate, :code_locate, 
        :entity_id)
    end 

end    

