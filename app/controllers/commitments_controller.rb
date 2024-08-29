class CommitmentsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @commitments = Commitment.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')  
             session.delete(:user_id)    
         end           
         
    end    

    def new
      @commitment = Commitment.new  
    end    

    def create
        @commitment = Commitment.new(commitment_params)

        if @commitment.save then
            redirect_back fallback_location: root_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end     
    end    
 
    def edit
        @commitment = Commitment.find(params[:id])
    end
    
    def update
        @commitment = Commitment.find(params[:id])
        if @commitment.update(commitment_params)
            redirect_to  crear_compromiso_evaluation_rule_detail_path(@commitment.evidence_id), notice: 'Compromiso actualizado correctamente'
        else
            render :edit, commitments: :unprocessable_entity
        end         
    end    

    def destroy
        @commitment = Commitment.find(params[:id])
        @commitment.destroy
        redirect_to  crear_compromiso_evaluation_rule_detail_path(@commitment.evidence_id), notice: 'Compromiso borrado correctamente', commitment: :see_other
    end     

    private
 
    def commitment_params 
        params.require(:commitment).permit(:activity, :user_responsible, :date_ejecution, :state_commitment, :evidence_id)
    end 

end  

