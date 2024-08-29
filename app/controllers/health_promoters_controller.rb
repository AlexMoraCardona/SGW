class HealthPromotersController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @health_promoters = HealthPromoter.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')   
             session.delete(:user_id)   
         end           
         
    end    

    def new
      @health_promoter = HealthPromoter.new  
    end    

    def create
        @health_promoter = HealthPromoter.new(health_promoter_params)

        if @health_promoter.save then
            redirect_to health_promoters_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @health_promoter = HealthPromoter.find(params[:id])
    end
    
    def update
        @health_promoter = HealthPromoter.find(params[:id])
        if @health_promoter.update(health_promoter_params)
            redirect_to health_promoters_path, notice: 'EPS actualizada correctamente'
        else
            render :edit, health_promoters: :unprocessable_entity
        end         
    end    

    def destroy
        @health_promoter = HealthPromoter.find(params[:id])
        @health_promoter.destroy
        redirect_to health_promoters_path, notice: 'EPS borrada correctamente', health_promoter: :see_other
    end     

    private

    def health_promoter_params 
        params.require(:health_promoter).permit(:name_entity, :code_entity, :nit_entity, :regime_entity)
    end 

end  

