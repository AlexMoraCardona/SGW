class HabilVotesController < ApplicationController
    def index
        if  Current.user && Current.user.level > 0 && Current.user.level < 3
            if params[:entity_id].present?
                @entity = Entity.find(params[:entity_id])
                @habil_votes = HabilVote.all.order(id: :desc)
            else 
                @entities = Entity.all
            end    
        elsif Current.user && Current.user.level == 3 
            @entity = Entity.find(Current.user.entity)
            @habil_votes = HabilVote.all.order(id: :desc)
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')    
            session.delete(:user_id)  
        end     
    end    

    def new
      @habil_vote = HabilVote.new  
    end    

    def create
        @habil_vote = HabilVote.new(habil_vote_params)

        if @habil_vote.save then
            redirect_back fallback_location: root_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end     
    end    
 
    def edit
        @habil_vote = HabilVote.find(params[:id])
    end
    
    def update
        @habil_vote = HabilVote.find(params[:id])
        if @habil_vote.update(habil_vote_params)
            redirect_to adm_votes_path, notice: 'Usuario hábil actualizado correctamente'
        else
            render :edit, adm_votes: :unprocessable_entity
        end         
    end    

    def destroy
        @habil_vote = HabilVote.find(params[:id])
        @habil_vote.destroy
        redirect_back fallback_location: root_path, notice: 'Usuario hábil borrado correctamente', adm_vote: :see_other
    end    

    private  
      
    def habil_vote_params
        params.require(:habil_vote).permit(:vote, :user_id, :adm_vote_id)
    end
end  

          