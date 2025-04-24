class Attendance < ApplicationRecord
    belongs_to :adm_attendance
    belongs_to :user

    def self.asistio(adm_attendance)
        busqueda = Attendance.where("user_id = ? and adm_attendance_id = ?",Current.user.id, adm_attendance.to_i)
        if busqueda.present?
            dato = 1
        else
            dato = 0
        end        
        return  dato 
    end

end
