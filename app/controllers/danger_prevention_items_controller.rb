class DangerPreventionItemsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @danger_prevention_items = DangerPreventionItem.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end           
         
    end    

    def new
      @danger_prevention_item = DangerPreventionItem.new  
    end    

    def create
        @danger_prevention_item = DangerPreventionItem.new(danger_prevention_item_params)

        if @danger_prevention_item.save then
            redirect_to danger_prevention_items_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @danger_prevention_item = DangerPreventionItem.find(params[:id])
    end
    
    def update
        @danger_prevention_item = DangerPreventionItem.find(params[:id])
        if @danger_prevention_item.update(danger_prevention_item_params)
            redirect_to danger_prevention_items_path, notice: 'Evaluación actualizada correctamente'
        else
            render :edit, danger_prevention_items: :unprocessable_entity
        end         
    end    

    def destroy
        @danger_prevention_item = DangerPreventionItem.find(params[:id])
        @danger_prevention_item.destroy
        redirect_to danger_prevention_items_path, notice: 'Evaluación borrada correctamente', danger_prevention_item: :see_other
    end    

    private

    def danger_prevention_item_params
        params.require(:danger_prevention_item).permit(:name, :description, :cant_questions, :percentage_min, :cant_attempts, :time_max, :img_exam)
    end 
    
end  

 
