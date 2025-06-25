class AdmVotesController < ApplicationController
    def index
        if  Current.user && Current.user.level > 0 && Current.user.level < 3
            if params[:entity_id].present?
                @entity = Entity.find(params[:entity_id])
                @adm_votes = AdmVote.where("entity_id = ?", params[:entity_id]).order(id: :desc)
            else 
                @entities = Entity.all
            end    
        elsif Current.user && Current.user.level == 3 
            @entity = Entity.find(Current.user.entity)
            @adm_votes = AdmVote.where("entity_id = ?",Current.user.entity)
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')    
            session.delete(:user_id)  
        end     
         
    end    

    def new
      @adm_vote = AdmVote.new  
    end    

    def create
        @adm_vote = AdmVote.new(adm_vote_params)

        if @adm_vote.save then
            AdmVote.crear_habiles(@adm_vote)
            redirect_to adm_votes_path(entity_id: @adm_vote.entity_id), notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end     
    end    
 
    def edit
        @adm_vote = AdmVote.find(params[:id])
    end
    
    def update
        @adm_vote = AdmVote.find(params[:id])
        if @adm_vote.update(adm_vote_params)
            redirect_to adm_votes_path(entity_id: @adm_vote.entity_id), notice: 'Parámetros de votaciones actualizado correctamente'
        else
            render :edit, assistants: :unprocessable_entity
        end         
    end    

    def destroy
        @adm_vote = AdmVote.find(params[:id])
        @adm_vote.destroy
        redirect_back fallback_location: root_path, notice: 'Parámetro de votaciones borrado correctamente', adm_vote: :see_other
    end  
    
    def ver_habiles
        @adm_vote = AdmVote.find(params[:id])        
        @habiles = HabilVote.where("adm_vote_id = ?",@adm_vote.id) if @adm_vote.present?
    end
    
    def crear_candidato
        @adm_vote = AdmVote.find(params[:id])
        @candidate_vote = CandidateVote.new         
        @candidate_votes = CandidateVote.where("adm_vote_id = ?",@adm_vote.id) if @adm_vote.present?
    end   

    def ver_votacion
        @votos = Vote.where("habil_vote_id = ?",params[:id]) if params[:id].present?
    end   
    
    def show
        @template = Template.where("format_number = ? and document_vigente = ?",101,1).last  
        @adm_vote = AdmVote.find(params[:id])
        @candidate_votes = CandidateVote.where("adm_vote_id = ?",@adm_vote.id) if @adm_vote.present?
        @entity = Entity.find(@adm_vote.entity_id) if @adm_vote.present?

    end    

    def adm_vote_pdf
        @template = Template.where("format_number = ? and document_vigente = ?",101,1).last  
        @adm_vote = AdmVote.find(params[:id])
        @candidate_votes = CandidateVote.where("adm_vote_id = ?",@adm_vote.id) if @adm_vote.present?
        @entity = Entity.find(@adm_vote.entity_id) if @adm_vote.present?

        @footer = 'Nit: ' + @entity.identification_number.to_s + ', Dirección: ' + @entity.entity_address.to_s


        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'verpdfvotos',
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
      
    def adm_vote_params
        params.require(:adm_vote).permit(:date_initial, :date_final, :total_candidates, :votes_max, :titulo_vote, :observation, :entity_id)
    end
end    

      


