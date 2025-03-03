class ViewVideosController < ApplicationController
    def index
        if  Current.user && (Current.user.level == 1 || Current.user.level == 2)
            #@view_videos = ViewVideo.all
            @q = ViewVideo.ransack(params[:q])
            @pagy, @view_videos = pagy(@q.result(user_id: :desc), items: 3)

         else
             redirect_to new_session_path, alert: t('common.not_logged_in')     
             session.delete(:user_id) 
         end           
    end    

    def new
      @view_video = ViewVideo.new  
    end    

    def create
        @view_video = ViewVideo.new(view_video_params)

        if @view_video.save then
            redirect_to view_videos_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @view_video = ViewVideo.find(params[:id])
    end
    
    def update
        @view_video = ViewVideo.find(params[:id])
        if @view_video.update(view_video_params)
            redirect_to view_videos_path, notice: 'Control de vista actualizada correctamente'
        else
            render :edit, view_videos: :unprocessable_entity
        end         
    end    

    def destroy
        @view_video = ViewVideo.find(params[:id])
        @view_video.destroy
        redirect_to view_videos_path, notice: 'Control de vista borrada correctamente', view_video: :see_other
    end   
    
    def registrar_vista
        presentation = Presentation.find(params[:id])
        if presentation.present?
            @view_video = ViewVideo.new 
            @view_video.name_view = presentation.name
            @view_video.user_id = Current.user.id
            @view_video.presentation = params[:id]
            @view_video.type_presentation = params[:type].to_i
            @view_video.date_view = Time.now
            if @view_video.save then
                if @view_video.type_presentation == 0
                    redirect_to listadopresentaciones_path, notice: t('.created') 
                else
                    redirect_to contents_path, notice: t('.created') 
                end    
            else
                render :presentations/listadopresentaciones, status: :unprocessable_entity
            end              
        else
            render :presentations/listadopresentaciones, status: :unprocessable_entity
        end    
    end    

    private

    def view_video_params
        params.require(:view_video).permit(:name_view, :presentation, :type_presentation, :date_view, :user_id)
    end 

end  