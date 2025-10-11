class LessonsController < ApplicationController
    def index 
        if Current.user && Current.user.level > 0 && Current.user.level < 4 
            @entity = Entity.find(Current.user.entity)
            @lessons = Lesson.where("entity_id = ?",Current.user.entity)
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')    
            session.delete(:user_id)  
        end     
    end  
    
    def show
        @lesson = Lesson.find(params[:id])
        @entity = Entity.find(@lesson.entity_id) if @lesson.present?
        @template = Template.where("format_number = ? and document_vigente = ?",105,1).last  
        @user_responsable = User.find(@lesson.user_adviser_sst) if @lesson.present? && @lesson.user_adviser_sst > 0
        @user_vigia = User.find(@lesson.user_vigia) if @lesson.present? && @lesson.user_vigia > 0

        @template = Template.where("format_number = ? and document_vigente = ?",105,1).last  
        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Lecciones.xlsx"'
            }
        end    
    end  
    
    def ver_leccion
        @lesson = Lesson.find(params[:id])
        @entity = Entity.find(@lesson.entity_id) if @lesson.present?
        @template = Template.where("format_number = ? and document_vigente = ?",105,1).last  
        @user_responsable = User.find(@lesson.user_adviser_sst) if @lesson.present? && @lesson.user_adviser_sst > 0
        @user_vigia = User.find(@lesson.user_vigia) if @lesson.present? && @lesson.user_vigia > 0

        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'ver_leccion',
                margin: {top: 10, bottom: 10, left: 10, right: 10 },
                disable_javascript: true,
                page_size: 'letter',
                footer: {
                    right: 'Página: [page] de [topage]'
                   }                
                       } 
        end
      
    end    

    def new
      @lesson =  Lesson.new
      @entity = Entity.find(Current.user.entity)
      @template = Template.where("format_number = ? and document_vigente = ?",105,1).last  
    end    

    def create
        @lesson = Lesson.new(lesson_params)
        if @lesson.save then
            redirect_to lessons_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
          @lesson = Lesson.find(params[:id])
          @entity = Entity.find(@lesson.entity_id)
          @template = Template.where("format_number = ? and document_vigente = ?",105,1).last  
    end
    
    def update
        @lesson = Lesson.find(params[:id])
        if @lesson.update(lesson_params)
            redirect_to lessons_path, notice: 'Lección actualizada correctamente'
        else
            render :edit, lessons: :unprocessable_entity
        end         
    end    

    def destroy
        @lesson = Lesson.find(params[:id])
        @lesson.destroy
        redirect_to lessons_path, notice: 'Lección borrada correctamente', lesson: :see_other
    end  

    def firma_leccion
        @lesson =   Lesson.find(params[:id])
        if @lesson.present?
            if Current.user.id == @lesson.user_adviser_sst
                @lesson.date_user_adviser_sst = Time.now
                @lesson.firm_user_adviser_sst = 1
            else    
                @lesson.date_user_vigia = Time.now
                @lesson.firm_user_vigia = 1
            end
        end    

        if Current.user.id == @lesson.user_adviser_sst || Current.user.id == @lesson.user_vigia 
            if @lesson.save then
                redirect_to lesson_path(@lesson.id), notice: "Firmado correctamente!"
            else
                redirect_to lessons_path, alert: "Se produjo un error en la firma." 
            end
        else
            redirect_to  home_path, alert: "Su usuario no corresponde con el nombre de la firma." 
        end    

    end    

    private

    def lesson_params
        params.require(:lesson).permit(:title, :user_adviser_sst, 
        :user_vigia, :date_user_adviser_sst, :date_user_vigia, 
        :firm_user_adviser_sst, :firm_user_vigia, :entity_id, 
        :user_id, :leccion_que, :leccion_causa, :leccion_recome)
    end 

end  

