class SimulacrumItemsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @simulacrum_items = SimulacrumItem.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')    
             session.delete(:user_id)  
         end           
         
    end    

    def new
      @simulacrum_item = SimulacrumItem.new  
    end    

    def create
        @simulacrum_item = SimulacrumItem.new(simulacrum_item_params)

        if @simulacrum_item.save then
            redirect_to simulacrum_path(@simulacrum_item.simulacrum_id), notice: 'Creado correctamente' 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @simulacrum_item = SimulacrumItem.find(params[:id])
    end
    
    def update
        @simulacrum_item = SimulacrumItem.find(params[:id])
 
        if @simulacrum_item.update(simulacrum_item_params)
            redirect_to simulacrum_path(@simulacrum_item.simulacrum_id), notice: 'Actualizado correctamente'
        else
            render :edit, simulacrum_items: :unprocessable_entity
        end         
    end    

    def destroy
        @simulacrum_item = SimulacrumItem.find(params[:id])
        @simulacrum_item.destroy
        redirect_to simulacrum_path(@simulacrum_item.simulacrum_id), notice: 'Borrado correctamente', simulacrum_item: :see_other
    end  
    

    private

    def simulacrum_item_params
        params.require(:simulacrum_item).permit(:clasification, :name, :position_exercise, :area_work, 
        :functions, :floor, :evacuated_personal_area, :evacuated_personal_name, :evacuated_personal_cargo, 
        :previous_activity, :date_previous, :responsible_previous, :time_sequence_crono, :activity_sequence, 
        :simulacrum_id)
    end 

end  
 


      