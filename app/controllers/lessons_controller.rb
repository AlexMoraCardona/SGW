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
        @user_responsable = User.find(@lesson.user_adviser_sst) if @lesson.present? && @lesson.user_adviser_sst > 0
        @user_vigia = User.find(@lesson.user_vigia) if @lesson.present? && @lesson.user_vigia > 0
        @template = Template.where("reference = ? and version = ?",@lesson.code,@lesson.version).last  
        @template_versions = Template.where(reference: @template.reference, standar_detail_item_id: @template.standar_detail_item_id).order(:date, :version) if @template.present?

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
        @user_responsable = User.find(@lesson.user_adviser_sst) if @lesson.present? && @lesson.user_adviser_sst > 0
        @user_vigia = User.find(@lesson.user_vigia) if @lesson.present? && @lesson.user_vigia > 0
        @template = Template.where("reference = ? and version = ?",@lesson.code,@lesson.version).last  
        @template_versions = Template.where(reference: @template.reference, standar_detail_item_id: @template.standar_detail_item_id).order(:date, :version) if @template.present?


        nombre_archivo = @template.reference.to_s + '.pdf'
        respond_to do |format| 
            format.html
            format.pdf {header_html = render_to_string( partial: 'templates/header')
                pdf = WickedPdf.new.pdf_from_string(
                    render_to_string('ver_leccion'),
                    disable_javascript: true,
                    margin: {top: 50, bottom: 10, left: 5, right: 5 },
                    page_size: 'letter',
                    header: {spacing: 5,
                    content: header_html}
                )  
                send_data(pdf, filename: nombre_archivo, disposition: 'attachment')      
            }
        end    
     
    end    

    def new
      @lesson =  Lesson.new
      @entity = Entity.find(Current.user.entity)
      @template = Template.where("reference = ? and document_vigente = ?",'LAAT-SST',1).last  

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
          @template = Template.where("reference = ? and version = ?",@lesson.code,@lesson.version).last  
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
        :user_id, :leccion_que, :leccion_causa, :leccion_recome, :version, :code)
    end 

end  

