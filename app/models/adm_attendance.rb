class AdmAttendance < ApplicationRecord
    belongs_to :entity
    belongs_to :user

    def self.contador(dato)
        adm_attendance =  AdmAttendance.find(dato)
        attendances = Attendance.where("adm_attendance_id = ?",adm_attendance.id) if adm_attendance.present?
        cant = 0
        cant = attendances.count if attendances.present?
        return  cant 
    end

end
