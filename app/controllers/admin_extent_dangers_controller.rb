class AdminExtentDangersController < ApplicationController
    def index
        if params[:entity_id].present?
            @entity = Entity.find(params[:entity_id])
            @admin_extent_dangers = AdminExtentDanger.where("entity_id = ?", params[:entity_id])
        else    
            if  Current.user && Current.user.level == 1
                @entities = Entity.all
                @admin_extent_dangers = AdminExtentDanger.all
            else
                redirect_to new_session_path, alert: t('common.not_logged_in')      
            end           
        end 
         
    end    

    def new
      @admin_extent_danger = AdminExtentDanger.new  
    end    

    
    def create
        @admin_extent_danger = AdminExtentDanger.new(admin_extent_danger_params)

        if @admin_extent_danger.save then
            redirect_to admin_extent_dangers_path, notice: 'Administración de medida creada correctamente', calendar: :see_other
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @admin_extent_danger = AdminExtentDanger.find(params[:id])
        @entity = Entity.find(@admin_extent_danger.entity_id) if @admin_extent_danger.present?
    end
    
    def update
        @admin_extent_danger = AdminExtentDanger.find(params[:id])
        if @admin_extent_danger.update(admin_extent_danger_params)
            redirect_to admin_extent_dangers_path, notice: 'Administración de medida actualizada correctamente'
        else
            render :edit, admin_extent_dangers: :unprocessable_entity
        end         
    end    

    def destroy
        @admin_extent_danger = AdminExtentDanger.find(params[:id])
        @admin_extent_danger.destroy
        redirect_to admin_extent_dangers_path, notice: 'Administración de medida borrada correctamente', admin_extent_danger: :see_other
    end    

    private

    def admin_extent_danger_params
        params.require(:admin_extent_danger).permit(:date_creation, :date_vencimiento, :state_extent, :entity_id)
    end 

end  

