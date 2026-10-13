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
      @template = Template.where("reference = ? and document_vigente = ?",'FV-SST',1).last  
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
        @adm_vote = AdmVote.find(params[:id])
        @candidate_votes = CandidateVote.where("adm_vote_id = ?",@adm_vote.id) if @adm_vote.present?
        @entity = Entity.find(@adm_vote.entity_id) if @adm_vote.present?
        @template = Template.where("reference = ? and version = ?",@adm_vote.code,@adm_vote.version).last  
        @template_versions = Template.where(reference: @template.reference, standar_detail_item_id: @template.standar_detail_item_id).order(:date, :version) if @template.present?


    end    

    def adm_vote_pdf
        @adm_vote = AdmVote.find(params[:id])
        @candidate_votes = CandidateVote.where("adm_vote_id = ?",@adm_vote.id) if @adm_vote.present?
        @entity = Entity.find(@adm_vote.entity_id) if @adm_vote.present?
        @template = Template.where("reference = ? and version = ?",@adm_vote.code,@adm_vote.version).last  
        @template_versions = Template.where(reference: @template.reference, standar_detail_item_id: @template.standar_detail_item_id).order(:date, :version) if @template.present?

        nombre_archivo = @template.reference.to_s + '.pdf'
        respond_to do |format| 
            format.html
            format.pdf {header_html = render_to_string( partial: 'templates/header')
                pdf = WickedPdf.new.pdf_from_string(
                    render_to_string('adm_vote_pdf'),
                    disable_javascript: true,
                    margin: {top: 50, bottom: 10, left: 5, right: 5 },
                    page_size: 'letter',
                    header: {spacing: 5,
                    content: header_html}
                )  
                send_data(pdf, filename: nombre_archivo, disposition: 'attachment')      
            }
        end    

    end    

    

    private  
      
    def adm_vote_params
        params.require(:adm_vote).permit(:date_initial, :date_final, :total_candidates, :votes_max, :titulo_vote, :observation, :entity_id, :version, :code)
    end
end    

      


