class OccupationalExamItemsController < ApplicationController
    def index 
        if  Current.user && Current.user.level == 1
            @occupational_exam_items = OccupationalExamItem.all
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')   
            session.delete(:user_id)   
        end           
    end  
    
    def new
      @occupational_exam_item = OccupationalExamItem.new  
    end    

    def create
        @occupational_exam_item = OccupationalExamItem.new(occupational_exam_item_params)

        if @occupational_exam_item.save then
            redirect_back fallback_location: root_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @occupational_exam_item = OccupationalExamItem.find(params[:id])
    end
    
    def update
        @occupational_exam_item = OccupationalExamItem.find(params[:id])
        if @occupational_exam_item.update(occupational_exam_item_params)
            redirect_to crear_item_occupational_occupational_exams_path(@occupational_exam_item.occupational_exam_id), notice: t('.created')
        else
            render :edit, annual_work_plans: :unprocessable_entity
        end         
    end    

    def destroy
        @occupational_exam_item = OccupationalExamItem.find(params[:id])
        @occupational_exam_item.destroy
        redirect_to occupational_exam_items_path, notice: 'Item borrado correctamente', occupational_exam_item: :see_other
    end    

    private

    def occupational_exam_item_params
        params.require(:occupational_exam_item).permit(:consecutive, :fec_exam, :fec_venc, :exam_type, 
        :nro_identification, :name, :post, :concept, :addressing, :recommendations, :restrictions,
         :sve, :action, :follow_up, :occupational_exam_id   )
    end  

end  

