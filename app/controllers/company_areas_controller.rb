class CompanyAreasController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @company_areas = CompanyArea.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')     
             session.delete(:user_id) 
         end           
         
    end    

    def new
      @company_area = CompanyArea.new  
    end    

    def create
        @company_area = CompanyArea.new(company_area_params)

        if @company_area.save then
            redirect_to company_areas_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @company_area = CompanyArea.find(params[:id])
    end
    
    def update
        @company_area = CompanyArea.find(params[:id])
        if @company_area.update(company_area_params)
            redirect_to company_areas_path, notice: 'Área actualizada correctamente'
        else
            render :edit, company_areas: :unprocessable_entity
        end         
    end    

    def destroy
        @company_area = CompanyArea.find(params[:id])
        @company_area.destroy
        redirect_to company_areas_path, notice: 'Área borrada correctamente', company_area: :see_other
    end    

    private

    def company_area_params
        params.require(:company_area).permit(:name, :entity_id )
    end 

end  