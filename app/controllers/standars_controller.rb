class StandarsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @standars = Standar.all.order(:rule_id, :cycle)
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end           
         
    end    

    def new
      @standar = Standar.new  
    end    

    def create
        @standar = Standar.new(standar_params)

        if @standar.save then
            redirect_to standars_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @standar = Standar.find(params[:id])
    end
    
    def update
        @standar = Standar.find(params[:id])
        if @standar.update(standar_params)
            redirect_to standars_path, notice: 'Clasificación actualizada correctamente'
        else
            render :edit, standars: :unprocessable_entity
        end         
    end    

    def destroy
        @standar = Standar.find(params[:id])
        @standar.destroy
        redirect_to standars_path, notice: 'Clasificación borrada correctamente', standar: :see_other
    end    

    private

    def standar_params
        params.require(:standar).permit(:name, :description, :value, :cycle, :rule_id)
    end 

end  

