class FormPreventionsController < ApplicationController
    def index
        if  Current.user && Current.user.level > 0 && Current.user.level < 3
            if params[:entity_id].present?
                @entity = Entity.find(params[:entity_id])
                @admin_extent_dangers = AdminExtentDanger.where("entity_id = ?", params[:entity_id]).order(id: :desc)
            else 
                @entities = Entity.all
            end    
        elsif Current.user && Current.user.level == 3 
            @entity = Entity.find(Current.user.entity)
            @admin_extent_dangers = AdminExtentDanger.where("entity_id = ?",Current.user.entity)
        elsif Current.user && Current.user.level == 5 
            @entity = Entity.find(Current.user.entity)
            @admin_extent_dangers = AdminExtentDanger.where("entity_id = ? and user_id = ?",Current.user.entity, Current.user.id)
        elsif Current.user && Current.user.level == 4 
            @entity = Entity.find(Current.user.entity)
            @admin_extent_dangers = AdminExtentDanger.where("entity_id = ? and user_id = ?",Current.user.entity, Current.user.id)
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')    
            session.delete(:user_id)  
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
        if  @admin_extent_danger.user_id.to_i == Current.user.id.to_i
        else
            redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma."
        end    

    end    


    private

    def form_prevention_params
        params.require(:form_prevention).permit(:eli, :sus, :ci, :ca, :epp, :admin_extent_danger_id, :clasification_danger_detail_id, :no_apply, :clasification_danger_id, :exposed)
    end
end  
