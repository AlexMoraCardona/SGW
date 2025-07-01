class EppRecuestsController < ApplicationController
    def index
        if  Current.user && Current.user.level > 0 && Current.user.level < 3
            if params[:entity_id].present?
           #@users = User.all.decorate

               @entity = Entity.find(params[:entity_id])
               @epp_recuests = EppRecuest.where("entity_id = ?", params[:entity_id])
               @q = @epp_recuests.ransack(params[:q])
               @pagy, @epp_recuests = pagy(@q.result(id: :desc), items: 3)
                
            else 
                @entities = Entity.all
            end    
        elsif Current.user && Current.user.level = 3 
            @entity = Entity.find(Current.user.entity)
            @epp_recuests = EppRecuest.where("entity_id = ?",Current.user.entity)
            @q = @epp_recuests.ransack(params[:q])
            @pagy, @epp_recuests = pagy(@q.result(id: :desc), items: 3)

        elsif Current.user && Current.user.level > 3 
            @entity = Entity.find(Current.user.entity)
            @epp_recuests = EppRecuest.where("entity_id = ? and user_id = ?",Current.user.entity,Current.user.id)
            @q = @epp_recuests.ransack(params[:q])
            @pagy, @epp_recuests = pagy(@q.result(id: :desc), items: 3)
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')    
            session.delete(:user_id)  
        end     

    end 

    def new
      @epp_recuest = EppRecuest.new  
      @protection_elements = ProtectionElement.where("entity = ?",Current.user.entity)
    end    

    def create
        @epp_recuest = EppRecuest.new(epp_recuest_params)

        if @epp_recuest.save then
            redirect_to epp_recuests_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @epp_recuest = EppRecuest.find(params[:id])
        @entity = Entity.find(@epp_recuest.entity_id) if @epp_recuest.present?
    end
    
    def show
        @epp_recuest = EppRecuest.find(params[:id])
        @entity = Entity.find(@epp_recuest.entity_id) if @epp_recuest.present?
    end

    def update
        @epp_recuest = EppRecuest.find(params[:id])
        if @epp_recuest.update(epp_recuest_params)
            redirect_to epp_recuests_path, notice: 'Solicitud de EPP actualizada correctamente'
        else
            render :edit, epp_recuests: :unprocessable_entity
        end         
    end    

    def destroy
        @epp_recuest = EppRecuest.find(params[:id])
        @epp_recuest.destroy
        redirect_to epp_recuests_path, notice: 'Solicitud de EPP borrada correctamente', epp_recuest: :see_other
    end    

    private

    def epp_recuest_params
        params.require(:epp_recuest).permit(:user_id, :protection_element_id, :entity_id, :date_recuest, :cantidad, :state_recuest, :date_delivery, :observation)
    end 
end  

        