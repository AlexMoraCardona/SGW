class InvesRecomendationsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @inves_recomendations = InvesRecomendation.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')    
             session.delete(:user_id)  
         end           
         
    end    

    def new
      @inves_recomendation = InvesRecomendation.new  
      @inves_recomendations = InvesRecomendation.where("investigation_id = ?",params[:id])  
    end    

    def create
        @inves_recomendation = InvesRecomendation.new(inves_recomendation_params)

        if @inves_recomendation.save then
            redirect_to investigations_path(params[entity_id: @inves_recomendation.investigation.entity_id]), notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @inves_recomendation = InvesRecomendation.find(params[:id])
    end
    
    def update
        @inves_recomendation = InvesRecomendation.find(params[:id])
        if @inves_recomendation.update(inves_recomendation_params)
            redirect_to investigations_path(params[entity_id: @inves_recomendation.investigation.entity_id]), notice: 'Recomendación actualizada correctamente'
        else
            render :edit, inves_recomendations: :unprocessable_entity
        end         
    end    

    def destroy
        @inves_recomendation = InvesRecomendation.find(params[:id])
        @inves_recomendation.destroy
        redirect_to investigations_path(params[entity_id: @inves_recomendation.investigation.entity_id]), notice: 'Investigación borrada correctamente', inves_recomendation: :see_other
    end    

    private

    def inves_recomendation_params
        params.require(:inves_recomendation).permit(:recomendation, :apply, :date_implementation, :responsible_implementation, :date_verification, :responsible_verification, :investigation_id)
    end 

end  

      