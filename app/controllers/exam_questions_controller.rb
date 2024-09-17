class ExamQuestionsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            #@exam_questions = ExamQuestion.all
            @q = ExamQuestion.ransack(params[:q])
            @pagy, @exam_questions = pagy(@q.result(id: :desc), items: 3)

         else
             redirect_to new_session_path, alert: t('common.not_logged_in')   
             session.delete(:user_id)   
         end           
         
    end    

    def new
      @exam_question = ExamQuestion.new  
    end    

    def create
        @exam_question = ExamQuestion.new(exam_question_params)

        if @exam_question.save then
            redirect_to exam_questions_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @exam_question = ExamQuestion.find(params[:id])
    end
    
    def update
        @exam_question = ExamQuestion.find(params[:id])
        if @exam_question.update(exam_question_params)
            redirect_to exam_questions_path, notice: 'Pregunta actualizada correctamente'
        else
            render :edit, exam_questions: :unprocessable_entity
        end         
    end    

    def destroy
        @exam_question = ExamQuestion.find(params[:id])
        @exam_question.destroy
        redirect_to exam_questions_path, notice: 'Pregunta borrada correctamente', exam_question: :see_other
    end    

    private

    def exam_question_params
        params.require(:exam_question).permit(:number, :question, :bad_answer_one, 
        :bad_answer_two, :bad_answer_three, :good_answe, :adm_exam_id, :img_question, :bad_answer_four)
    end 

end  

