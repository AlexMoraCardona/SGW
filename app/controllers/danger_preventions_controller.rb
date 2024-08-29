class DangerPreventionsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            if params[:format].present?
                @danger_preventions = DangerPrevention.where("clasification_danger_detail_id = ?", params[:format])
            else
                @danger_preventions = DangerPrevention.all
            end    
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')  
             session.delete(:user_id)    
         end           
         
    end    

    def new
      @danger_prevention  = DangerPrevention.new  
    end    

    def create
        @danger_prevention = DangerPrevention.new(danger_prevention_params)

        if @danger_prevention.save then
            redirect_to edit_clasification_danger_detail_path(@danger_prevention.clasification_danger_detail_id), notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @danger_prevention = DangerPrevention.find(params[:id])
    end
    
    def update
        @danger_prevention = DangerPrevention.find(params[:id])
        if @danger_prevention.update(danger_prevention_params)
            redirect_to edit_clasification_danger_detail_path(@danger_prevention.clasification_danger_detail_id), notice: 'Sugerencia de medida de prevención y control actualizada correctamente'
        else
            render :edit, danger_preventions: :unprocessable_entity
        end         
    end    

    def destroy
        @danger_prevention = DangerPrevention.find(params[:id])
        @danger_prevention.destroy
        redirect_to edit_clasification_danger_detail_path(@danger_prevention.clasification_danger_detail_id), notice: 'Sugerencia de medida de prevención y control borrada correctamente', danger_detail_risk: :see_other
    end    

    private

    def danger_prevention_params
        params.require(:danger_prevention).permit(:name, :clasification_danger_detail_id)
    end 

end  