class CandidateVotesController < ApplicationController
    def index
        if  Current.user && Current.user.level > 0 && Current.user.level < 3
            if params[:entity_id].present?
                @entity = Entity.find(params[:entity_id])
                @candidate_votes = CandidateVote.all.order(id: :desc)
            else 
                @entities = Entity.all
            end    
        elsif Current.user && Current.user.level == 3 
            @entity = Entity.find(Current.user.entity)
            @candidate_votes = CandidateVote.all.order(id: :desc)
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')    
            session.delete(:user_id)  
        end     
    end    

    def new
      @candidate_vote = CandidateVote.new 

    end    

    def create
        @candidate_vote = CandidateVote.new(candidate_vote_params)
        @candidate_vote.activity = User.label_activity(User.find(@candidate_vote.user.id).activity) if @candidate_vote.present?
        @candidate_votes = CandidateVote.where("adm_vote_id = ?",@candidate_vote.adm_vote_id) if @candidate_vote.present?
 
        if @candidate_votes.present? && @candidate_votes.count >= @candidate_vote.adm_vote.total_candidates
            redirect_to crear_candidato_path(@candidate_vote.adm_vote_id), alert: 'No es posible crear Candidato alcanzo el límite maximo de candidatos'
        elsif @candidate_vote.save then
            redirect_back fallback_location: root_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end     
    end    
 
    def edit
        @candidate_vote = CandidateVote.find(params[:id])
    end
    
    def update 
        @candidate_vote = CandidateVote.find(params[:id])
        
        if @candidate_vote.update(candidate_vote_params)
            redirect_to crear_candidato_path(@candidate_vote.adm_vote_id), notice: 'Candidato actualizado correctamente'
        else
            render :edit, adm_votes: :unprocessable_entity
        end         
    end    

    def destroy
        @candidate_vote = CandidateVote.find(params[:id])
        @candidate_vote.destroy
        redirect_to crear_candidato_path(@candidate_vote.adm_vote_id), notice: 'Candidato borrado correctamente', adm_vote: :see_other
    end    

    private  
      
    def candidate_vote_params
        params.require(:candidate_vote).permit(:activity, :observations, :adm_vote_id, :user_id, :avatar_candidate)
    end
end  

      