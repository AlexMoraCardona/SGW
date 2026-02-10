class AllowExam < ApplicationRecord
    belongs_to :user
    belongs_to :adm_exam
    belongs_to :entity

    has_many :exams


    def self.crear_citar(n, id, vector)
        i = 0
        while i < n
            @allow_exam = AllowExam.find(id.to_i) if id.present?
            @user = User.find(vector[i].to_i)
            @user_convoca = User.find(@allow_exam.user_id)
            UserMailer.with(user: @user, reunion: @allow_exam.name_exam, observaciones: @allow_exam.description, fecha_inicio: @allow_exam.date_initial, fecha_final: @allow_exam.date_final, convocanombre: @user_convoca.name, convocacargo: @user_convoca.cargo_rol).citacion_exam.deliver_later
            i = i + 1
        end        
    end

end
