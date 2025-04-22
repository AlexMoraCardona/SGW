class DetailDiseasesController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            if params[:format].present?
                @detail_diseases = DetailDisease.where("table_disease_id = ?", params[:format].to_i)

                @q = @detail_diseases.ransack(params[:q])
                @pagy, @detail_diseases = pagy(@q.result(table_disease_id: :desc), items: 3)
            else
                @detail_diseases = DetailDisease.all
                @q = DetailDisease.ransack(params[:q])
                @pagy, @detail_diseases = pagy(@q.result(id: :desc), items: 3)                
            end    
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')     
             session.delete(:user_id) 
         end           
         
    end    

    def new
      @detail_disease  = DetailDisease.new  
    end    

    def create
        @detail_disease = DetailDisease.new(detail_disease_params)

        if @detail_disease.save then
            redirect_to detail_diseases_path(@detail_disease.table_disease_id), notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @detail_disease = DetailDisease.find(params[:id].to_i)
    end
    
    def update
        @detail_disease = DetailDisease.find(params[:id].to_i)
        if @detail_disease.update(detail_disease_params)
            redirect_to detail_diseases_path(@detail_disease.table_disease_id), notice: 'Enfermedad actualizada correctamente'
        else
            render :edit, detail_diseases: :unprocessable_entity
        end         
    end    

    def destroy
        @detail_disease = DetailDisease.find(params[:id].to_i)
        @detail_disease.destroy
        redirect_to detail_diseases_path, notice: 'Enfermedad borrada correctamente', detail_disease: :see_other
    end    

    private

    def detail_disease_params
        params.require(:detail_disease).permit(:name, :code_disease, :table_disease_id)
    end 

end  
