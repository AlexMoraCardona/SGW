class MeetingMinutesController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @meeting_minutes = MeetingMinute.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end           
         
    end  
    
    def show
        @meeting_minute = MeetingMinute.find(params[:id])
        @meeting_attendees = MeetingAttendee.where("meeting_minute_id = ?",@meeting_minute.id)
        @meeting_commitments = MeetingCommitment.where("meeting_minute_id = ?",@meeting_minute.id)
        @assistants = Assistant.where("meeting_minute_id = ?",@meeting_minute.id)

        respond_to do |format|
            format.html
            format.pdf {render  pdf: 'Acta',
                margin: {top: 10, bottom: 10, left: 10, right: 10 },
                disable_javascript: true,
                page_size: 'letter',
                footer: {
                    right: 'Página: [page] de [topage]'
                   }                
                       } 
        end
    end    

    def new
        @meeting_minute = MeetingMinute.new  
    end    

    def crear_asistente
        @meeting_attendee = MeetingAttendee.new  
        @meeting_attendees = MeetingAttendee.where("meeting_minute_id = ?", params[:id]) if params[:id].present?
    end    

    def crear_compromiso
        @meeting_commitment = MeetingCommitment.new  
        @meeting_commitments = MeetingCommitment.where("meeting_minute_id = ?", params[:id]) if params[:id].present?
    end    

    def crear_firma
        @assistant = Assistant.new  
        @assistants = Assistant.where("meeting_minute_id = ?", params[:id]) if params[:id].present?
    end    

    
    def create
        @meeting_minute = MeetingMinute.new(meeting_minute_params)
        if @meeting_minute.save then
            redirect_to meeting_minutes_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @meeting_minute = MeetingMinute.find(params[:id])
        @meeting_attendees = MeetingAttendee.where("meeting_minute_id = ?",@meeting_minute.id)
        @meeting_commitments = MeetingCommitment.where("meeting_minute_id = ?",@meeting_minute.id)
        @assistants = Assistant.where("meeting_minute_id = ?",@meeting_minute.id)

    end
    
    def update
        @meeting_minute = MeetingMinute.find(params[:id])
        if @meeting_minute.update(meeting_minute_params)
            redirect_to meeting_minutes_path, notice: 'Acta actualizada correctamente'
        else
            render :edit, meeting_minutes: :unprocessable_entity
        end         
    end    

    def destroy
        @meeting_minute = MeetingMinute.find(params[:id])
        @meeting_minute.destroy
        redirect_to meeting_minutes_path, notice: 'Acta borrada correctamente', meeting_minute: :see_other
    end    

    private 

    def meeting_minute_params
        params.require(:meeting_minute).permit(:date, :start_time, :end_time, :code, :version,
        :record_number, :area_process_committee, :objective_meeting, :meeting_type, :place, 
        :order_day, :Issues, :miscellaneous_propositions, :elaborated, :entity_id, :user_id, :evaluation_id)
    end 

end    