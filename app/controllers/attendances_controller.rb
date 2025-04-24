class AttendancesController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @adm_attendances = AdmAttendance.where("entity_id = ? and date_attendance = ?", Current.user.entity.to_i, Time.now)
         else
            if Current.user && Current.user.level > 1
                @adm_attendances = AdmAttendance.where("entity_id = ? and date_attendance = ?", Current.user.entity.to_i, Time.now)
            else  
                redirect_to new_session_path, alert: t('common.not_logged_in') 
                session.delete(:user_id)      
            end
         end           
         
    end    

    def new
      @attendance = Attendance.new  
    end    

    def create
        @attendance = Attendance.new(attendance_params)

        if @attendance.save then
            redirect_to attendances_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @attendance = Attendance.find(params[:id])
    end
    
    def update
        @attendance = Attendance.find(params[:id])
        if @attendance.update(attendance_params)
            redirect_to attendances_path, notice: 'Asistencia actualizada correctamente'
        else
            render :edit, attendances: :unprocessable_entity
        end         
    end    

    def destroy
        @attendance = Attendance.find(params[:id])
        @attendance.destroy
        redirect_to attendances_path, notice: 'Asistencia borrada correctamente', attendance: :see_other
    end  
    
    def registrar_asistencia
        adm_attendance = AdmAttendance.find(params[:id])
        if adm_attendance.present?
            @attendance = Attendance.new 
            @attendance.date_attendance = Time.now
            @attendance.confirm_attendance = 1
            @attendance.adm_attendance_id = adm_attendance.id
            @attendance.user_id = Current.user.id
            if @attendance.save then
                    redirect_to attendances_path, notice: t('.created') 
            else
                redirect_to attendances_path, status: :unprocessable_entity
            end              
        else
            render :attendances, status: :unprocessable_entity
        end    
    end 
    

    private

    def attendance_params
        params.require(:attendance).permit(:date_attendance, :confirm_attendance, :adm_attendance_id, :user_id)
    end 

end  

