class CessationFundsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @cessation_funds = CessationFund.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in') 
             session.delete(:user_id)     
         end           
         
    end    

    def new
      @cessation_fund = CessationFund.new  
    end    

    def create
        @cessation_fund = CessationFund.new(cessation_fund_params)

        if @cessation_fund.save then
            redirect_to cessation_funds_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @cessation_fund = CessationFund.find(params[:id])
    end
    
    def update
        @cessation_fund = CessationFund.find(params[:id])
        if @cessation_fund.update(cessation_fund_params)
            redirect_to cessation_funds_path, notice: 'Fondo de Cesantías actualizado correctamente'
        else
            render :edit, cessation_funds: :unprocessable_entity
        end         
    end    

    def destroy
        @cessation_fund = CessationFund.find(params[:id])
        @cessation_fund.destroy
        redirect_to cessation_funds_path, notice: 'Fondo de Cesantías borrado correctamente', cessation_fund: :see_other
    end     

    private

    def cessation_fund_params 
        params.require(:cessation_fund).permit(:name, :code, :nit )
    end 

end  
