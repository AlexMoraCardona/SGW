class MeetingMinutesController < ApplicationController
    def index
        if  Current.user && Current.user.level > 0 && Current.user.level < 3 
            @meetings = MeetingMinute.all.order(id: :desc)
            @q = @meetings.ransack(params[:q])
            @pagy, @meeting_minutes = pagy(@q.result(date: :desc), items: 3)
        elsif  Current.user && Current.user.level == 3 || Current.user && Current.user.ccl == 1 || Current.user && Current.user.secretary_copasst == 1
            @meetings = MeetingMinute.where("entity_id = ?",Current.user.entity).order(id: :desc)
            @q = @meetings.ransack(params[:q])
            @pagy, @meeting_minutes = pagy(@q.result(date: :desc), items: 3)

         else
             redirect_to new_session_path, alert: t('common.not_logged_in')    
             session.delete(:user_id)  
         end           
         
    end  
    
    def show
        @meeting_minute = MeetingMinute.find(params[:id])
        @entity = Entity.find(@meeting_minute.entity_id) if @meeting_minute.present?
        @meeting_attendees = MeetingAttendee.where("meeting_minute_id = ?",@meeting_minute.id) if @meeting_minute.present?
        @meeting_commitments = MeetingCommitment.where("meeting_minute_id = ?",@meeting_minute.id).order(:id) if @meeting_minute.present?
        @assistants = Assistant.where("meeting_minute_id = ?",@meeting_minute.id) if @meeting_minute.present?
        @template = Template.where("format_number = ? and document_vigente = ?",79,1).last  
        
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
        @template = Template.where("format_number = ? and document_vigente = ?",79,1).last  
        @entity = Entity.find(Current.user.entity) if Current.present?
        @evaluation = Evaluation.where("entity_id = ?",@entity.id).last if @entity.present?
        @meeting_minutes = MeetingMinute.where("entity_id = ?",@entity) if @entity.present?
        if @meeting_minutes.present?
            @numero_acta = @meeting_minutes.count + 1
        else
            @numero_acta = 1
        end 
        
        @meeting_minute.order_day = "<strong>Orden del Día:</strong> <br>1 Verificación de Quórum.<br/> <br>2 Lectura del Acta Anterior<br/> <br>3 Revisión de Compromisos Anteriores<br/> <br>4 Temas para esta Reunión<br/>"

    end    

    def crear_asistente
        @meeting_attendee = MeetingAttendee.new  
        @meeting_attendees = MeetingAttendee.where("meeting_minute_id = ?", params[:id]) if params[:id].present?
    end    

    def crear_compromiso
        @meeting_commitment = MeetingCommitment.new  
        @meeting_commitments = MeetingCommitment.where("meeting_minute_id = ?", params[:id]).order(:id) if params[:id].present?
    end    

    def crear_firma
        @assistant = Assistant.new  
        @assistants = Assistant.where("meeting_minute_id = ?", params[:id]) if params[:id].present?
    end    

    
    def create
        @meeting_minute = MeetingMinute.new(meeting_minute_params)
        @meeting_minute.version =  0 if  @meeting_minute.version.blank?
        @meeting_minutes = MeetingMinute.where("entity_id = ? and version = ?",@meeting_minute.entity_id,@meeting_minute.version) if @meeting_minute.present?
               
        if @meeting_minutes.present?
            @meeting_minute.record_number = @meeting_minutes.count + 1
        else
            @meeting_minute.record_number = 1
        end 


        if @meeting_minute.save then
            redirect_to meeting_minutes_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @meeting_minute = MeetingMinute.find(params[:id])
        @entity = Entity.find(@meeting_minute.entity_id) if @meeting_minute.present?
        @meeting_attendees = MeetingAttendee.where("meeting_minute_id = ?",@meeting_minute.id) if @meeting_minute.present?
        @meeting_commitments = MeetingCommitment.where("meeting_minute_id = ?",@meeting_minute.id).order(:id) if @meeting_minute.present?
        @assistants = Assistant.where("meeting_minute_id = ?",@meeting_minute.id) if @meeting_minute.present?
        @template = Template.where("format_number = ? and document_vigente = ?",79,1).last  

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

    def crear_copia_acta
        MeetingMinute.copiar_acta(params[:id])
        nuevo = MeetingMinute.last
        MeetingAttendee.copiar_asistentes(params[:id], nuevo.id)
        MeetingCommitment.copiar_compromisos(params[:id], nuevo.id)
        Assistant.copiar_firmas(params[:id], nuevo.id)
        redirect_to meeting_minutes_path, notice: 'Acta copiadaa correctamente', meeting_minute: :see_other
    end  

    private 

    def meeting_minute_params
        params.require(:meeting_minute).permit(:date, :start_time, :end_time, :code, :version,
        :record_number, :area_process_committee, :objective_meeting, :meeting_type, :place, 
        :order_day, :Issues, :miscellaneous_propositions, :elaborated, :entity_id, :user_id, :evaluation_id)
    end 

end    