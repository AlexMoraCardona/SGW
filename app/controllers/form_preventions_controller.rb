class FormPreventionsController < ApplicationController
    def index
        if params[:entity_id].present? && Current.user 
            @entity = Entity.find(params[:entity_id])
            @admin_extent_dangers = AdminExtentDanger.where("entity_id = ? and date_creation <= ? and date_vencimiento >= ? and state_extent = ?", params[:entity_id].to_i, Date.today, Date.today, 1)  
        else    
            if  Current.user 
                @entities = Entity.all.order(id: :asc) if Current.user.level == 1
                @entities = Entity.find(Current.user.entity) if Current.user.level != 1 
            else
                redirect_to new_session_path, alert: t('common.not_logged_in')      
            end           
        end
    end    

    def create
        @form_prevention = FormPrevention.new(form_prevention_params)

        if @form_prevention.save then
            redirect_to home_path, notice: t('.created') 
        else
            redirect_back fallback_location: root_path, alert: "Su formulario no pudo ser enviado."
        end    
    end    

    def informesuge 
        @form_prevention = FormPrevention.new 
        @user_id =  params[:id].to_i  if params[:id].present?
        @admin_extent_danger_id =  params[:admin_extent_danger_id].to_i  if params[:admin_extent_danger_id].present?
        user = User.find(@user_id) if @user_id.present?
        @entity = Entity.find(user.entity)
    end

    private

    def form_prevention_params
        params.require(:form_prevention).permit(:eli, :sus, :ci, :ca, :epp, :admin_extent_danger_id, 
        :user_id, :danger_prevention_id)
    end
end  