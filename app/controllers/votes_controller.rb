class VotesController < ApplicationController
    def index
        if  Current.user
            @adm_votes = AdmVote.where("entity_id = ? and date_initial <= ? and date_final >= ?", Current.user.entity,Time.now,Time.now).order(id: :desc)
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')    
            session.delete(:user_id)  
        end     
    end    

    def new
      @vote = Vote.new  
      @adm_vote = AdmVote.find(params[:adm_id]) if params[:adm_id].present?
    end    

    def create
        @vote = Vote.new(vote_params)
        @vote.user_id = Current.user.id
        @vote.date_vote = Time.now
        @vote.candidate_vote_id = params[:vote][:datovoto].to_i 
        @vote.adm_vote_id = @vote.candidate_vote.adm_vote_id 
        habil_vote = HabilVote.find_by(user_id: @vote.user_id, adm_vote_id: @vote.adm_vote_id) if @vote.adm_vote_id.present? and @vote.user_id.present?
        @vote.habil_vote_id = habil_vote.id if habil_vote.present?
        habil_vote.vote  = 1  

        @adm_vote = AdmVote.find(@vote.adm_vote_id) if @vote.adm_vote_id.present?
        resultado = Vote.validar_usuario(@adm_vote)

        if resultado == 1 && @vote.save then
            habil_vote.save 
            redirect_back fallback_location: root_path, notice: 'Voto creado correctamente' 
        else
            redirect_back fallback_location: root_path, alert: 'Usuario no se encuentra hábil para votar', vote: :see_other  if resultado == 0            
            redirect_back fallback_location: root_path, alert: 'Su usuario ya aparece registrado en las votaciones', vote: :see_other  if resultado == 2              
        end     
    end    
 
    def edit
        @vote = Vote.find(params[:id])
    end
    
    def update
        @vote = Vote.find(params[:id])
        if @vote.update(vote_params)
            redirect_to votes_path, notice: 'Voto actualizado correctamente'
        else
            render :edit, votes: :unprocessable_entity
        end         
    end    

    def destroy
        @vote = Vote.find(params[:id])
        @vote.destroy
        redirect_back fallback_location: root_path, notice: 'Voto borrado correctamente', vote: :see_other
    end 
    
    def validar_votacion
        @adm_vote = AdmVote.find(params[:id]) if params[:id].present?
        resultado = Vote.validar_usuario(@adm_vote)
        if resultado == 1 
            redirect_to new_vote_path(adm_id: @adm_vote.id)
        else
            redirect_back fallback_location: root_path, alert: 'Usuario no se encuentra hábil para votar', vote: :see_other  if resultado == 0            
            redirect_back fallback_location: root_path, alert: 'Su usuario ya aparece registrado en las votaciones', vote: :see_other  if resultado == 2              
        end    

    end     

    private  
      
    def vote_params
        params.require(:vote).permit(:date_vote, :user_id, :adm_vote_id, :candidate_vote_id, :habil_vote_id)
    end
end  


   
          