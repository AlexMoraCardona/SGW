class AllowExamsController < ApplicationController
    def index
        if  Current.user && Current.user.level > 0 && Current.user.level < 3
            @allow_exams = AllowExam.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')   
             session.delete(:user_id)   
         end           
         
    end    

    def new
      @allow_exam = AllowExam.new  
    end    

    def create
        @allow_exam = AllowExam.new(allow_exam_params)
        @adm_exam = AdmExam.find(@allow_exam.adm_exam_id)  if @allow_exam.present?
        @allow_exam.name_exam = @adm_exam.description if @adm_exam.present? 
         
        if @allow_exam.save then
            redirect_to allow_exams_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @allow_exam = AllowExam.find(params[:id])
    end
    
    def update
        @allow_exam = AllowExam.find(params[:id])
        if @allow_exam.update(allow_exam_params)
            redirect_to allow_exams_path, notice: 'Autorización actualizada correctamente'
        else
            render :edit, allow_exams: :unprocessable_entity
        end         
    end    

    def destroy
        @allow_exam = AllowExam.find(params[:id])
        @allow_exam.destroy
        redirect_to allow_exams_path, notice: 'Autorización borrada correctamente', allow_exam: :see_other
    end    

    private

    def allow_exam_params
        params.require(:allow_exam).permit(:date_initial, :date_final, :user_id, 
        :adm_exam_id, :entity_id, :name_exam, :description)
    end 

end  

