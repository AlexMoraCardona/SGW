class ExamDetailsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @exam_details = ExamDetail.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end           
         
    end    

    def new
      @exam_detail = ExamDetail.new  
    end    

    def create
        @exam_detail = ExamDetail.new(exam_detail_params)
        if @exam_detail.save then
            notice: 'Respuesta guardada correctamente' 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @exam_detail = ExamDetail.find(params[:id])
    end
    
    def update
        @exam_detail = ExamDetail.find(params[:id])
        if @exam_detail.update(exam_detail_params)
            redirect_to exam_details_path, notice: 'Respuesta actualizada correctamente'
        else
            render :edit, exam_details: :unprocessable_entity
        end         
    end    

    def destroy
        @exam_detail = ExamDetail.find(params[:id])
        @exam_detail.destroy
        redirect_to exam_details_path, notice: 'Respuesta borrada correctamente', exam_detail: :see_other
    end    

    private

    def exam_detail_params
        params.require(:exam_detail).permit(:answer_user, :correct, :exam_id, :exam_question_id)
    end 

end  
