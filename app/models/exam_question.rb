class ExamQuestion < ApplicationRecord
    belongs_to :adm_exam
    has_one_attached :img_question

    def self.crear_preguntas(id)
        @preguntas = []
        @pregunta = ExamQuestion.find(id) if id.present?
        @preguntas.push([@pregunta.bad_answer_one]) if @pregunta.present?
        @preguntas.push([@pregunta.bad_answer_two]) if @pregunta.present?
        @preguntas.push([@pregunta.bad_answer_three]) if @pregunta.present?
        @preguntas.push([@pregunta.bad_answer_four]) if @pregunta.present?
        @preguntas.push([@pregunta.good_answe]) if @pregunta.present?
        @preguntas.shuffle!
        return @preguntas
    end   
    
    def self.ransackable_attributes(auth_object = nil)
        ["number", "question", "adm_exam_id" ]
    end   
    
end
