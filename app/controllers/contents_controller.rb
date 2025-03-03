class ContentsController < ApplicationController
    def index

        if  Current.user && Current.user.level == 1
            @contents = Content.where(state: 1).order(:clasification)
            @vistas = ViewVideo.where(user_id: Current.user.id)
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')  
             session.delete(:user_id)    
         end          
         
    end    

    def new
      @content = Content.new  
    end    

    def create
        @content = Content.new(content_params)

        if @content.save then
            redirect_to fallback_location: root_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @content = Content.find(params[:id])
    end
    
    def update 
        @content = Content.find(params[:id])
        if @content.update(content_params)
            redirect_to contents_path, notice: 'Multimedia actualizada correctamente'
        else
            render :edit, contents: :unprocessable_entity
        end         
    end    

    def destroy
        @content = Content.find(params[:id])
        @content.destroy
        redirect_to contents_path, notice: 'Multimedia borrada correctamente', content: :see_other
    end    

    private

    def content_params
        params.require(:content).permit(:state, :title, :clasification, :link)
    end 

end  
