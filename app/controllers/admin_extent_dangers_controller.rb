class AdminExtentDangersController < ApplicationController
    def index
        if params[:entity_id].present?
            @entity = Entity.find(params[:entity_id])
            @admin_extent_dangers = AdminExtentDanger.where("entity_id = ?", params[:entity_id]).order(id: :desc)
        else    
            if  Current.user && Current.user.level == 1
                @entities = Entity.all
                @admin_extent_dangers = AdminExtentDanger.all.order(id: :desc)
            else
                redirect_to new_session_path, alert: t('common.not_logged_in')   
                session.delete(:user_id)   
            end           
        end 
         
    end    

    def new
      @admin_extent_danger = AdminExtentDanger.new  
    end    

    
    def create
        @admin_extent_danger = AdminExtentDanger.new(admin_extent_danger_params)
        if @admin_extent_danger.save then
            crear_detalle(@admin_extent_danger)
            redirect_to edit_form_prevention_path(@admin_extent_danger.id)
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
            redirect_to form_preventions_path(entity_id: @admin_extent_danger.entity_id), notice: 'Administración de medida actualizada correctamente'
        else
            render :edit, admin_extent_dangers: :unprocessable_entity
        end         
    end    

    def destroy
        @admin_extent_danger = AdminExtentDanger.find(params[:id])
        @admin_extent_danger.destroy
        redirect_to admin_extent_dangers_path, notice: 'Administración de medida borrada correctamente', admin_extent_danger: :see_other
    end 

    def crear_admin_extent

        @admin_extent_danger = AdminExtentDanger.new 
        @entity = Entity.find(Current.user.entity) if Current.user.present?

        
        #@admin_extent_danger.save

        #crear_detalle(@admin_extent_danger)

        #redirect_to form_preventions_path(entity_id: @admin_extent_danger.entity_id), notice: 'Por favor diligencie el nuevo formulario'
    end  
    
    def crear_detalle(admin)
        @clasification_danger_details = ClasificationDangerDetail.all
        @clasification_danger_details.each do |cla| 
            @form_prevention = FormPrevention.new
            @form_prevention.admin_extent_danger_id = admin.id.to_i
            @form_prevention.clasification_danger_detail_id = cla.id
            @form_prevention.clasification_danger_id = cla.clasification_danger_id
            @form_prevention.no_apply = 1
            @form_prevention.created_at = Time.now
            @form_prevention.updated_at = Time.now
            @form_prevention.save
        end  
    end    

    def matrix_prevention
        @template = Template.where("format_number = ? and document_vigente = ?",56,1).last  
        @admin_extent_danger = AdminExtentDanger.find(params[:id])
        @form_preventions = FormPrevention.where("admin_extent_danger_id = ?", @admin_extent_danger.id) if @admin_extent_danger.present?
        @entity = Entity.find(@admin_extent_danger.entity_id) if @admin_extent_danger.present?
        @cant = 0
    end    
    
    def matrix_vista
        @template = Template.where("format_number = ? and document_vigente = ?",56,1).last  
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
        params.require(:admin_extent_danger).permit(:date_creation, :date_vencimiento, :state_extent, :entity_id, 
        :firm_user, :date_firm_user, :user_id, :post, :type_contract, :received_training, :suffered_accident, 
        :epp, :epp_cuales, :area, :equipment_operates, :control_proposal, :cual_suffered_accident)
    end 

end  

    