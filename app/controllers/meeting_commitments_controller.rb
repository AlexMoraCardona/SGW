class MeetingCommitmentsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @meeting_commitments = MeetingCommitment.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')  
             session.delete(:user_id)    
         end           
         
    end    

    def new
      @meeting_commitment = MeetingCommitment.new  
    end    

    def create
        @meeting_commitment = MeetingCommitment.new(meeting_commitment_params)
        @meeting_commitment.responsible = @meeting_commitment.user.name
        if @meeting_commitment.save then
            UserMailer.with(user: @meeting_commitment.user, fechaacor: @meeting_commitment.date_commitment, compromiso: @meeting_commitment.commitment, esperado: @meeting_commitment.state_commitment, nombreelaboro: @meeting_commitment.meeting_minute.user.name, cargo: User.label_activity(@meeting_commitment.meeting_minute.user.activity)).compromiso.deliver_later 
            redirect_back fallback_location: root_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end     
    end    
 
    def edit
        @meeting_commitment = MeetingCommitment.find(params[:id])
    end
    
    def update
        @meeting_commitment = MeetingCommitment.find(params[:id])
        if @meeting_commitment.update(meeting_commitment_params)
            redirect_back fallback_location: root_path, notice: 'Compromiso actualizado correctamente'
        else
            render :edit, meeting_commitments: :unprocessable_entity
        end         
    end    

    def destroy
        @meeting_commitment = MeetingCommitment.find(params[:id])
        @meeting_commitment.destroy
        redirect_back fallback_location: root_path, notice: 'Compromiso borrado correctamente', meeting_commitment: :see_other
    end    

    private     
    def meeting_commitment_params
        params.require(:meeting_commitment).permit(:number, :commitment, :responsible, :meeting_minute_id, :date_commitment, :state_commitment, :user_id)
    end

end    

