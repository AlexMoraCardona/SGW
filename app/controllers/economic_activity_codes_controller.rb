class EconomicActivityCodesController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @economic_activity_codes = EconomicActivityCode.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')    
             session.delete(:user_id)  
         end           

    end    

    def new
      @economic_activity_code = EconomicActivityCode.new  
    end    

    def create
        @economic_activity_code = EconomicActivityCode.new(economic_activity_code_params)

        if @economic_activity_code.save then
            redirect_to economic_activity_codes_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @economic_activity_code = EconomicActivityCode.find(params[:id])
    end
    
    def update
        @economic_activity_code = EconomicActivityCode.find(params[:id])
        if @economic_activity_code.update(economic_activity_code_params)
            redirect_to economic_activity_codes_path, notice: 'Actividad económica actualizada correctamente'
        else
            render :edit, economic_activity_codes: :unprocessable_entity
        end         
    end    

    def destroy
        @economic_activity_code = EconomicActivityCode.find(params[:id])
        @economic_activity_code.destroy
        redirect_to economic_activity_codes_path, notice: 'Actividad económica borrada correctamente', economic_activity_code: :see_other
    end    

    private

    def economic_activity_code_params
        params.require(:economic_activity_code).permit(:risk_class, :ciu_code, :additional_digits, :economic_activity_description)
    end 

end  

