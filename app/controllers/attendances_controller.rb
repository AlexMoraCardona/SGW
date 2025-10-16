class AttendancesController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @attendances = Attendance.where("user_id = ?", Current.user.id.to_i).order(id: :desc)
         else
            if Current.user && Current.user.level > 1
                @attendances = Attendance.where("user_id = ?", Current.user.id.to_i).order(id: :desc)
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
        attendance = Attendance.find(params[:id])
        if attendance.present? &&  (attendance.adm_attendance.date_attendance  + 7.days)  > Time.now      
            attendance.date_attendance = Time.now
            attendance.confirm_attendance = 1
            if attendance.save then
                    redirect_to attendances_path, notice: t('.created') 
            else
                redirect_to attendances_path, status: :unprocessable_entity
            end              
        else
            redirect_to attendances_path, alert: 'No fue posible actualizar su asistencia', attendance: :see_other
        end    
    end 
    

    private

    def attendance_params
        params.require(:attendance).permit(:date_attendance, :confirm_attendance, :adm_attendance_id, :user_id)
    end 

end  

