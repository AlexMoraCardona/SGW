class FormPreventionsController < ApplicationController
    def index
        if params[:entity_id].present? && Current.user 
            @entity = Entity.find(params[:entity_id])
            if Current.user.level == 1 || Current.user.level == 2 then
                @admin_extent_dangers = AdminExtentDanger.where("entity_id = ?", params[:entity_id].to_i).order(id: :desc)  
            else
                @admin_extent_dangers = AdminExtentDanger.where("entity_id = ? and user_id = ?", params[:entity_id].to_i, Current.user.id).order(id: :desc)  
            end                    
                
        else     
            if  Current.user  
                @entities = Entity.all.order(id: :asc) if Current.user.level == 1
                @entitie = Entity.find(Current.user.entity) if Current.user.level != 1 
            else
                redirect_to new_session_path, alert: t('common.not_logged_in')    
                session.delete(:user_id)  
            end           
        end
    end    

    def create
        @form_prevention = FormPrevention.new(form_prevention_params)
        if @form_prevention.save then
            redirect_back fallback_location: root_path, notice: "Su respuesta fue enviada correctamente." 
        else
            redirect_back fallback_location: root_path, alert: "Su formulario no pudo ser enviado."
        end    
    end   
    
    def edit 
        @admin_extent_danger = AdminExtentDanger.find(params[:id])
        @entity = Entity.find(@admin_extent_danger.entity_id) if @admin_extent_danger.present?
        @form_preventions = FormPrevention.where("admin_extent_danger_id = ?", @admin_extent_danger).order(:clasification_danger_id) if @admin_extent_danger.present?
        @clasification_dangers  = ClasificationDanger.all
    end
    
    def update
            @form_prevention = FormPrevention.find(params[:id])
            
            if @form_prevention.update(form_prevention_params)
                if Current.user.level == 2 then  
                    redirect_to  matrix_prevention_admin_extent_dangers_path(@form_prevention.admin_extent_danger_id), notice: 'Actualizado correctamente'
                else    
                    redirect_to edit_form_prevention_path(@form_prevention.admin_extent_danger_id), notice: 'Actualizado correctamente'
                end    
            else
                render :edit, form_preventions: :unprocessable_entity
            end         
    end  
    
    def actualizar_form_prevention
        @form_prevention = FormPrevention.find(params[:id])
    end    

    def encuestapre
        @form_prevention = FormPrevention.find(params[:id].to_i)
        @clasification_danger_detail = ClasificationDangerDetail.find(@form_prevention.clasification_danger_detail_id) if @form_prevention.present?

    end   
    
    def firmar_admin_extent
        @admin_extent_danger = AdminExtentDanger.find(params[:id].to_i)
        if  @admin_extent_danger.user_id.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
        else
            redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma."
        end    

    end    


    private

    def form_prevention_params
        params.require(:form_prevention).permit(:eli, :sus, :ci, :ca, :epp, :admin_extent_danger_id, :clasification_danger_detail_id, :no_apply, :clasification_danger_id, :exposed)
    end
end  
