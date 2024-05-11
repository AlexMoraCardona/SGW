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
    
    def matrix_prevention
        @template = Template.find(169)
        @admin_extent_danger = AdminExtentDanger.find(params[:id])
        @form_preventions = FormPrevention.where("admin_extent_danger_id = ?", @admin_extent_danger.id) if @admin_extent_danger.present?
        @entity = Entity.find(@admin_extent_danger.entity_id) if @admin_extent_danger.present?
        @cant = 0
    end    
    
    def matrix_vista
        @template = Template.find(169)
        @admin_extent_danger = AdminExtentDanger.find(params[:id])
        @form_preventions = FormPrevention.where("admin_extent_danger_id = ?", @admin_extent_danger.id) if @admin_extent_danger.present?
        @entity = Entity.find(@admin_extent_danger.entity_id) if @admin_extent_danger.present?
        @cant = 0
        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'matrix_vista',
                margin: {top: 10, bottom: 10, left: 10, right: 10 },
                disable_javascript: true,
                page_size: 'letter',
                footer: {
                    right: 'Página: [page] de [topage]'
                   }                
                       } 
        end
    end      

    private

    def admin_extent_danger_params
        params.require(:admin_extent_danger).permit(:date_creation, :date_vencimiento, :state_extent, :entity_id)
    end 

end  

