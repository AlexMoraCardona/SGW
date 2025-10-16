class AdmAttendancesController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @adm_attendances = AdmAttendance.all.order(id: :desc)
        else
            if Current.user && Current.user.level > 1
                @adm_attendances = AdmAttendance.where(entity_id: Current.user.entity).order(id: :desc)
            else  
                redirect_to new_session_path, alert: t('common.not_logged_in') 
                session.delete(:user_id)      
            end
        end        
    end    

    def new
      @adm_attendance = AdmAttendance.new  
    end    

    def create
        @adm_attendance = AdmAttendance.new(adm_attendance_params)

        if @adm_attendance.save then
            redirect_to adm_attendances_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @adm_attendance = AdmAttendance.find(params[:id])
    end
    
    def update
        @adm_attendance = AdmAttendance.find(params[:id])
        if @adm_attendance.update(adm_attendance_params)
            redirect_to adm_attendances_path, notice: 'Asistencia capacitación actualizada correctamente'
        else
            render :edit, adm_attendances: :unprocessable_entity
        end         
    end    

    def destroy
        @adm_attendance = AdmAttendance.find(params[:id])
        @adm_attendance.destroy
        redirect_to adm_attendances_path, notice: 'Asistencia capacitación borrada correctamente', adm_attendance: :see_other
    end
    
    def adm_attendance_pdf
        @adm_attendance =  AdmAttendance.find(params[:id])
        @entity = Entity.find(@adm_attendance.entity_id) if @adm_attendance.present?
        @attendances = Attendance.where("adm_attendance_id = ?",@adm_attendance.id) if @adm_attendance.present?
        @template = Template.where("format_number = ? and document_vigente = ?",95,1).last
        nombre_evidencia = 'Listado Asistencia ' + @adm_attendance.description.to_s + @adm_attendance.date_attendance.to_s + '.pdf'

        respond_to do |format| 
            format.html
            format.pdf {
                header_html = render_to_string( partial: 'adm_attendances/header')
                pdf = WickedPdf.new.pdf_from_string(
                    render_to_string('adm_attendance_pdf'),
                    disable_javascript: true,
                    margin: {top: 50, bottom: 15, left: 15, right: 15 },
                    page_size: 'letter',
                    header: {spacing: 5,
                            content: header_html},
                    footer: {right: '[page] de [topage]'}
                    
                  )  
                  send_data(pdf, filename: nombre_evidencia, disposition: 'attachment')      
            }
        end    


    end    

    def seleccion_participantes
            @users = User.where("entity = ? and state = ?", Current.user.entity, 1)
    end 

    def citar_participantes
        vector = params[:ids] 
        n = 0
        n = params[:ids].count if params[:ids].present?
        id_adm_attendance = params[:id].to_i if params[:id].present?

        if n > 0
            AdmAttendance.crear_participantes(n, vector, id_adm_attendance)
            redirect_to adm_attendances_path, notice: 'Participantes creados correctamente', calendar: :see_other
        else
            redirect_to adm_attendances_path, status: :unprocessable_entity, alert: 'No se seleccionó ningun usuario.' 
        end    

    end    



    private

    def adm_attendance_params
        params.require(:adm_attendance).permit(:date_attendance, :description, :time_initial, :time_final, :entity_id, :user_id)
    end 

end  

