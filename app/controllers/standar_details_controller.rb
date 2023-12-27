class StandarDetailsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @standar_details = StandarDetail.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end           
         
    end    

    def new
      @standar_detail = StandarDetail.new  
    end    

    def create
        @standar_detail = StandarDetail.new(standar_detail_params)

        if @standar_detail.save then
            redirect_to standar_details_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @standar_detail = StandarDetail.find(params[:id])
    end
    
    def update
        @standar_detail = StandarDetail.find(params[:id])
        if @standar_detail.update(standar_detail_params)
            redirect_to standar_details_path, notice: 'Estándar actualizado correctamente'
        else
            render :edit, standar_details: :unprocessable_entity
        end         
    end    

    def destroy
        @standar_detail = StandarDetail.find(params[:id])
        @standar_detail.destroy
        redirect_to standar_details_path, notice: 'Estándar borrado correctamente', standar_detail: :see_other
    end    

    private

    def standar_detail_params
        params.require(:standar_detail).permit(:description, :value, :standar_id)
    end 

end  


