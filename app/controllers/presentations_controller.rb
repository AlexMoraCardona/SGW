class PresentationsController < ApplicationController
    def index
        if  Current.user
            @presentations = Presentation.where(state: 1).order(:id)
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')  
             session.delete(:user_id)    
         end           
         
    end    

    def new
      @presentation = Presentation.new  
      @empresas = Entity.select(:business_name, :id).all
    end    

    def create
        @presentation = Presentation.new(presentation_params)

        if @presentation.save then
            redirect_to presentations_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @presentation = Presentation.find(params[:id])
        @empresas = Entity.select(:business_name, :id).all
    end
    
    def update
        @presentation = Presentation.find(params[:id])
        if @presentation.update(presentation_params)
            redirect_to presentations_path, notice: 'Presentación actualizada correctamente'
        else
            render :edit, presentations: :unprocessable_entity
        end         
    end    

    def destroy
        @presentation = Presentation.find(params[:id])
        @presentation.destroy
        redirect_to presentations_path, notice: 'Presentación borrada correctamente', presentation: :see_other
    end  
    
    def listadopresentaciones
        @presentations = Presentation.all.order(:id)
    end 
    
    def show 
        @presentations = Presentation.where("state = ? and (entity = ? or entity = ?)",1,Current.user.entity,6).order(:id)
        @vistas = ViewVideo.where(user_id: Current.user.id)
    end    

    private

    def presentation_params
        params.require(:presentation).permit(:name, :archivo, :state, :entity)
    end 

end  