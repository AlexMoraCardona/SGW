class ParticipantsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @participants = Participant.all.decorate
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
             session.delete(:user_id)
         end           
         
    end    

    def new
      @participant = Participant.new   
    end    

    def create
        @participant = Participant.new(participant_params)

        if @participant.save then
            redirect_to crear_participant_evaluation_rule_detail_path(@participant.evidence_id), notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @participant = Participant.find(params[:id])
    end
    
    def update
        @participant = Participant.find(params[:id])
        if @participant.update(participant_params)
            redirect_to crear_participant_evaluation_rule_detail_path(@participant.evidence_id), notice: 'Funcionario actualizado correctamente'
        else
            render :edit, participants: :unprocessable_entity
        end         
    end    

    def destroy
        @participant = Participant.find(params[:id])
        eviden = @participant.evidence_id
        @participant.destroy
        redirect_to crear_participant_evaluation_rule_detail_path(eviden), notice: 'Funcionario borrado correctamente', participant: :see_other
    end    

    private

    def participant_params
        params.require(:participant).permit(:arl_activity_report, :quote_10_aditional_points, :degree, 
        :designating_by_legal_representative, :joint_committee_president, :joint_committee_secretary, 
        :post_copasst, :user_id, :evidence_id, :responsible_ssst, :external_consultant, :collaborator, 
        :reported_activity, :employees_activity, :vigia, :jury_voting, :candidate, :number_votes, :workers_representative, 
        :company_representative, :person_complaining, :choose, :rh, :company_position, :phone, :brigade_position, :brigade_personnel)
    end 

end  

