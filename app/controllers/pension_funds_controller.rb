class PensionFundsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @pension_funds = PensionFund.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end           
         
    end    

    def new
      @pension_fund = PensionFund.new  
    end    

    def create
        @pension_fund = PensionFund.new(pension_fund_params)

        if @pension_fund.save then
            redirect_to pension_funds_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @pension_fund = PensionFund.find(params[:id])
    end
    
    def update
        @pension_fund = PensionFund.find(params[:id])
        if @pension_fund.update(pension_fund_params)
            redirect_to pension_funds_path, notice: 'Fondo de Pensiones actualizado correctamente'
        else
            render :edit, pension_funds: :unprocessable_entity
        end         
    end    

    def destroy
        @pension_fund = PensionFund.find(params[:id])
        @pension_fund.destroy
        redirect_to pension_funds_path, notice: 'Fondo de Pensiones borrado correctamente', pension_fund: :see_other
    end     

    private

    def pension_fund_params 
        params.require(:pension_fund).permit(:fund, :code_fund )
    end 

end  
