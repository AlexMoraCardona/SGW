class AdmExamsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @adm_exams = AdmExam.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end           
         
    end    

    def new
      @adm_exam = AdmExam.new  
    end    

    def create
        @adm_exam = AdmExam.new(adm_exam_params)

        if @adm_exam.save then
            redirect_to adm_exams_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @adm_exam = AdmExam.find(params[:id])
    end
    
    def update
        @adm_exam = AdmExam.find(params[:id])
        if @adm_exam.update(adm_exam_params)
            redirect_to adm_exams_path, notice: 'Evaluación actualizada correctamente'
        else
            render :edit, adm_exams: :unprocessable_entity
        end         
    end    

    def destroy
        @adm_exam = AdmExam.find(params[:id])
        @adm_exam.destroy
        redirect_to adm_exams_path, notice: 'Evaluación borrada correctamente', adm_exam: :see_other
    end    

    private

    def adm_exam_params
        params.require(:adm_exam).permit(:name, :description, :cant_questions, :percentage_min, :cant_attempts, :time_max, :img_exam)
    end 
end  

 
