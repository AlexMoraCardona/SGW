class Exam < ApplicationRecord
    belongs_to :user
    belongs_to :adm_exam
    belongs_to :allow_exam
    has_many :exam_details
    
    def self.leerparametro(parametro, exam_details)
        if parametro.present?
            para = parametro
            tama = para.length
            corchete = 0
            i = 0
            while i < tama
                if para[i] == "["
                    corchete = i
                end    
                i = i + 1
            end
            if corchete > 0
                ques = para[0..(corchete -1)]
                resp = para[(corchete + 2)..-3]
            end    
            exam_detail = exam_details.find_by(exam_question_id: ques.to_i)
            if  exam_detail.present?
                exam_detail.answer_user = resp

                if exam_detail.answer_user == exam_detail.exam_question.good_answe
                    exam_detail.correct = 1
                else
                    exam_detail.correct = 0
                end        
                exam_detail.save
            end    
        end
    end   
    
    def self.calcular(id)
        @exam = Exam.find(id) if id.present?
        @exam_details = ExamDetail.where("exam_id = ?", @exam.id) if @exam.present?
        @adm_exam = AdmExam.find(@exam.adm_exam_id.to_i)
        aprobados = 0
        @exam_details.each do |exam_detail|
            aprobados += 1 if exam_detail.correct == 1              
        end    
        @exam.final_percentage = (((Float(aprobados) / @adm_exam.cant_questions))*100).round(2) 
        @exam.total_good = aprobados
        @exam.total_bad  = @adm_exam.cant_questions - aprobados
        @exam.percentage_min = @adm_exam.percentage_min
        if @exam.final_percentage < @exam.percentage_min
            @exam.resul = 'Reprobado'
        else
            @exam.resul = 'Aprobado'
        end
        @exam.save
    end   
    
    def self.numero_empleados(entidad, date_initial, date_final)  
        empleados = User.where("entity = ? and level > ? and (date_entry_company <= ? or date_entry_company is null) and (date_retirement_company >= ? or date_retirement_company is null)",entidad.to_i, 2, date_initial, date_final)
        cant = empleados.count
        return cant
    end    

    def self.realiza(entidad, adexa, date_initial, date_final) 
        @datos = []
        empleados = User.where("entity = ? and level > ? and (date_entry_company <= ? or date_entry_company is null) and (date_retirement_company >= ? or date_retirement_company is null)",entidad.to_i, 2, date_initial, date_final)

        cantemp = 0
        cantemp = empleados.count
        cant = 0
        apro = 0
        repro = 0
        porapro = 0
        porrepro = 0

        empleados.each do |empleado|
            id_exam = Exam.where("user_id = ? and allow_exam_id = ?", empleado.id.to_i, adexa.to_i).order(:final_percentage).last
            if id_exam.present?
                cant += 1  
                apro += 1 if id_exam.resul == "Aprobado" 
                repro += 1 if id_exam.resul == "Reprobado" || id_exam.resul.blank?  
            end    
        end

        porapro = (((Float(apro) / cantemp))*100).round(2) 
        porrepro = (((Float(repro) / cantemp))*100).round(2) 
        @datos.push(cant, apro, repro, porapro, porrepro)
        return  @datos;
   end     

   def self.detalle_realiza(entidad, adexa) 
        allow_exam = AllowExam.find(adexa)
        empleados = User.where("entity = ? and level > ? and (date_entry_company <= ? or date_entry_company is null) and (date_retirement_company >= ? or date_retirement_company is null)",entidad.to_i, 2, allow_exam.date_initial, allow_exam.date_final)

        @exams = [] 
        empleados.each do |empleado|
            id_exam = Exam.where("user_id = ? and allow_exam_id = ?", empleado.id.to_i, adexa.to_i).order(:final_percentage).last
            if id_exam.present?
                @exams << id_exam
            end    
        end
       return  @exams;
    end     

    def self.intentos(user, allow_exam) 
        @can = 0 
        exa = Exam.where("user_id = ? and allow_exam_id = ?", user.to_i, allow_exam.to_i)
        @can = exa.count if exa.present?
        return @can;
    end  
    
    def self.filtro_exams(allow_exam_id)
        @can_filtro_exams = 0    
        @can_filtro_exams = Exam.where("allow_exam_id = ?", allow_exam_id)
        return @can_filtro_exams;
    end    
end
