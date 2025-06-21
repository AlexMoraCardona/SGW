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

    def self.asistentes(dato)
        adm_attendance =  AdmAttendance.find(dato)
        @attendances = Attendance.where("adm_attendance_id = ?",adm_attendance.id) if adm_attendance.present?
    end    

    def self.pendientes(dato)
        adm_attendance =  AdmAttendance.find(dato)
        attendances = Attendance.where("adm_attendance_id = ?",adm_attendance.id) if adm_attendance.present?
        users = User.where("entity = ? and state = ? and level > ?",adm_attendance.entity_id,1,2) if adm_attendance.present?

        ca = []
        if users.present?
            users.each do |u|
                sw = 0
                if attendances.present?
                    attendances.each do |a|
                        if u.id == a.user_id
                          sw = 1  
                        end    
                    end    
                end
                if sw == 0
                    ca.push(u.name)                     
                end    
            end    
        end
        return  ca 
    end


end
