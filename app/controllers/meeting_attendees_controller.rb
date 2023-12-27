class MeetingAttendeesController < ApplicationController

    def index
        if  Current.user && Current.user.level == 1
            @meeting_attendees = MeetingAttendee.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end           
         
    end    

    def new 
      @meeting_attendee = MeetingAttendee.new  

    end    

    def create
        @meeting_attendee = MeetingAttendee.new(meeting_attendee_params)
        if @meeting_attendee.save then
            redirect_back fallback_location: root_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end     
    end    
 
    def edit
        @meeting_attendee = MeetingAttendee.find(params[:id])
    end
    
    def update
        
        @meeting_attendee = MeetingAttendee.find(params[:id])
        if @meeting_attendee.update(meeting_attendee_params)
            redirect_back fallback_location: root_path, notice: 'Asistente actualizado correctamente'
        else
            render :edit, meeting_attendees: :unprocessable_entity
        end         
    end    

    def destroy
        @meeting_attendee = MeetingAttendee.find(params[:id])
        @meeting_attendee.destroy
        redirect_back fallback_location: root_path, notice: 'Asistente borrado correctamente', meeting_attendee: :see_other
    end    

    private     
    def meeting_attendee_params
        params.require(:meeting_attendee).permit(:name, :post, :process_area, :meeting_minute_id)
    end 
end    