class CompanyPositionsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @company_positions = CompanyPosition.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')     
             session.delete(:user_id) 
         end           
         
    end    

    def new
      @company_position = CompanyPosition.new  
    end    

    def create
        @company_position = CompanyPosition.new(company_position_params)

        if @company_position.save then
            redirect_to company_positions_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @company_position = CompanyPosition.find(params[:id])
    end
    
    def update
        @company_position = CompanyPosition.find(params[:id])
        if @company_position.update(company_position_params)
            redirect_to company_positions_path, notice: 'Cargo actualizado correctamente'
        else
            render :edit, company_positions: :unprocessable_entity
        end         
    end    

    def destroy
        @company_position = CompanyPosition.find(params[:id])
        @company_position.destroy
        redirect_to company_positions_path, notice: 'Cargo borrado correctamente', company_position: :see_other
    end    

    private

    def company_position_params
        params.require(:company_position).permit(:name, :entity_id )
    end 

end  