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
        @attendances = Attendance.where("adm_attendance_id = ? and confirm_attendance = ?",adm_attendance.id,1) if adm_attendance.present?
    end    

    def self.pendientes(dato)
        adm_attendance =  AdmAttendance.find(dato)
        attendances = Attendance.where("adm_attendance_id = ? and confirm_attendance = ?",adm_attendance.id,0) if adm_attendance.present?

        ca = []
        if attendances.present?
            attendances.each do |u|
                ca.push(u.user.name)                     
            end    
        end
        return  ca 
    end


    def self.crear_participantes(n, vector, id_adm_attendance)
        i = 0
        while i < n
            @attendance = Attendance.new
            @attendance.user_id = vector[i].to_i
            @attendance.adm_attendance_id = id_adm_attendance
            @attendance.confirm_attendance = 0
            @attendance.save
 
            i = i + 1
        end        
    end



end
