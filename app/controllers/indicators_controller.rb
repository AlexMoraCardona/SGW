class IndicatorsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @indicators = Indicator.all 
        else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end           
    end    

    def new
      @indicator = Indicator.new 
      @cycles = Cycle.all 
    end    

    def create
        @indicator = Indicator.new(indicator_params)

        if @indicator.save then
            redirect_to indicators_path, notice: t('.created') 
        else
            render :new, indicators: :unprocessable_entity
        end    
    end    
 
    def edit
        @indicator = Indicator.find(params[:id])
        @cycles = Cycle.all 
    end
    
    def update
        @indicator = Indicator.find(params[:id])
        if @indicator.update(indicator_params)
            redirect_to indicators_path, notice: 'Nivel actualizado correctamente'
        else
            render :edit, status: :unprocessable_entity
        end         
    end    

    def destroy
        @indicator = Indicator.find(params[:id])
        @indicator.destroy
        redirect_to indicators_path, notice: 'Nivel borrado correctamente', indicator: :see_other
    end    

    private

    def indicator_params
        params.require(:indicator).permit(:name, :description, :cycle_id, :periodicity, :formula, :interpretation, :limit_one, :limit_two, :information_source, :responsible_management)
    end 

end    

