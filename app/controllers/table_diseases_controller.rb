class TableDiseasesController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @table_diseases = TableDisease.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')    
             session.delete(:user_id)  
         end           
         
    end    

    def new
      @table_disease = TableDisease.new  
    end    

    def create
        @table_disease = TableDisease.new(table_disease_params)

        if @table_disease.save then
            redirect_to table_diseases_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @table_disease = TableDisease.find(params[:id])
    end
    
    def update
        @table_disease = TableDisease.find(params[:id])
        if @table_disease.update(table_disease_params)
            redirect_to table_diseases_path, notice: 'Clasificación de enfermedad actualizada correctamente'
        else
            render :edit, table_diseases: :unprocessable_entity
        end         
    end    

    def destroy
        @table_disease = TableDisease.find(params[:id])
        @table_disease.destroy
        redirect_to table_diseases_path, notice: 'Clasificación de enfermedad borrada correctamente', table_disease: :see_other
    end    

    private

    def table_disease_params
        params.require(:table_disease).permit(:clasification_disease)
    end 

end  
