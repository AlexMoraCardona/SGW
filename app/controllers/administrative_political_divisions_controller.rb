class AdministrativePoliticalDivisionsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @administrative_political_divisions = AdministrativePoliticalDivision.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in') 
             session.delete(:user_id)     
         end          
         
    end    

    def new
      @administrative_political_division = AdministrativePoliticalDivision.new  
    end    

    def create
        @administrative_political_division = AdministrativePoliticalDivision.new(administrative_political_division_params)

        if @administrative_political_division.save then
            redirect_to administrative_political_divisions_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @administrative_political_division = AdministrativePoliticalDivision.find(params[:id])
    end
    
    def update
        @administrative_political_division = AdministrativePoliticalDivision.find(params[:id])
        if @administrative_political_division.update(administrative_political_division_params)
            redirect_to administrative_political_divisions_path, notice: 'Ubicación actualizada correctamente'
        else
            render :edit, administrative_political_divisions: :unprocessable_entity
        end         
    end    

    def destroy
        @administrative_political_division = AdministrativePoliticalDivision.find(params[:id])
        @administrative_political_division.destroy
        redirect_to administrative_political_divisions_path, notice: 'Ubicación borrada correctamente', administrative_political_division: :see_other
    end    

    private

    def administrative_political_division_params
        params.require(:administrative_political_division).permit(:department_code, :department_name, :municipality_code, :municipality_name, :town_center_name, :town_center_code, :classification )
    end 

end  