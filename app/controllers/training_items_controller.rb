class TrainingItemsController < ApplicationController
    def index 
        if  Current.user && Current.user.level == 1
            @training_items = TrainingItem.all
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')      
        end           
    end  
    
    def new
      @training_item = TrainingItem.new  
    end    

    def create
        @training_item = TrainingItem.new(training_item_params)
        
        if @training_item.save then
            TrainingItem.calculos(@training_item.id)
            redirect_back fallback_location: root_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @training_item = TrainingItem.find(params[:id])
    end
    
    def update
        @training_item = TrainingItem.find(params[:id])
        if @training_item.update(training_item_params)
            TrainingItem.calculos(@training_item.id)
            redirect_to crear_item_training_trainings_path(@training_item.training_id), notice: t('.created')
        else
            render :edit, trainings: :unprocessable_entity
        end         
    end    

    def destroy
        @training_item = TrainingItem.find(params[:id])
        @training_item.destroy
        redirect_back fallback_location: root_path, notice: 'Capacitación o Actividad borrada correctamente!', training_item: :see_other
    end    

    private

    def training_item_params
        params.require(:training_item).permit(:consecutive, :duration, :goals,
        :training_topic, :resources, :scope, :responsible, :date_training, :training_coverage_percentage, 
        :observation, :percentage_trained_workers, :training_id, :cant_emple, :cant_emple_cap, :cant_cap, :state_cap )
    end  

end  


