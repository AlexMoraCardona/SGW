class ClasificationDangerDetailsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            if params[:format].present?
                @clasification_danger_details = ClasificationDangerDetail.where("clasification_danger_id = ?", params[:format])
            else
                @clasification_danger_details = ClasificationDangerDetail.all
            end    
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end           
         
    end    

    def new
      @clasification_danger_detail  = ClasificationDangerDetail.new  
    end    

    def create
        @clasification_danger_detail = ClasificationDangerDetail.new(clasification_danger_detail_params)

        if @clasification_danger_detail.save then
            redirect_to clasification_danger_details_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @clasification_danger_detail = ClasificationDangerDetail.find(params[:id])
    end
    
    def update
        @clasification_danger_detail = ClasificationDangerDetail.find(params[:id])
        if @clasification_danger_detail.update(clasification_danger_detail_params)
            redirect_to clasification_danger_details_path, notice: 'Item actualizado correctamente'
        else
            render :edit, clasification_danger_details: :unprocessable_entity
        end         
    end    

    def destroy
        @clasification_danger_detail = ClasificationDangerDetail.find(params[:id])
        @clasification_danger_detail.destroy
        redirect_to clasification_danger_details_path, notice: 'Item borrado correctamente', clasification_danger_detail: :see_other
    end    

    private

    def clasification_danger_detail_params
        params.require(:clasification_danger_detail).permit(:name, :clasification_danger_id)
    end 

end  
