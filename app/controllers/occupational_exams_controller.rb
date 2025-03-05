class OccupationalExamsController < ApplicationController
    def index 
        if params[:entity_id].present?
            @entity = Entity.find(params[:entity_id])
            @occupational_exams = OccupationalExam.where("entity_id = ?", params[:entity_id])
        else    
            if  Current.user && Current.user.level > 0 && Current.user.level < 4
                @entities = Entity.all
                @occupational_exams = OccupationalExam.all
            else
                redirect_to new_session_path, alert: t('common.not_logged_in') 
                session.delete(:user_id)     
            end           
        end 
    end  
    
    def show
        @occupational_exam = OccupationalExam.find(params[:id])
        @occupational_exam_items = OccupationalExamItem.where("occupational_exam_id = ?", @occupational_exam.id) if @occupational_exam.present?
        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Evaluacion.xlsx"'
            }
        end    
    end  
    
    def ver_occupational
        @occupational_exam = OccupationalExam.find(params[:id])
        @occupational_exam_items = OccupationalExamItem.where("occupational_exam_id = ?", @occupational_exam.id) if @occupational_exam.present?

        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'ver_occupational',
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
      @occupational_exam =  OccupationalExam.new
      @template = Template.where("format_number = ? and document_vigente = ?",35,1).last  
    end    

    def create
        @occupational_exam = OccupationalExam.new(occupational_exam_params)
        if @occupational_exam.save then
            redirect_to occupational_exams_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @occupational_exam = OccupationalExam.find(params[:id])
    end
    
    def update
        @occupational_exam = OccupationalExam.find(params[:id])
        if @occupational_exam.update(occupational_exam_params)
            redirect_to occupational_exams_path, notice: 'Matriz de seguimiento exámenes ocupacionales actualizada correctamente'
        else
            render :edit, occupational_exams: :unprocessable_entity
        end         
    end    

    def destroy
        @occupational_exam = OccupationalExam.find(params[:id])
        @occupational_exam.destroy
        redirect_to occupational_exams_path, notice: 'Matriz de seguimiento exámenes ocupacionales borrada correctamente', occupational_exam: :see_other
    end  
    
    def crear_item_occupational
        @occupational_exam_item = OccupationalExamItem.new  
        @cant = 0
        @occupational_exam_items = OccupationalExamItem.where("occupational_exam_id = ?", params[:id]) if params[:id].present?
        @cant = @occupational_exam_items.count if @occupational_exam_items.present?
        @cant = @cant + 1 
    end    

    def firmar_rep 
        @occupational_exam = OccupationalExam.find_by(id: params[:id].to_i)
        if params[:format].to_i == 1
            if  @occupational_exam.user_legal_representative.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_rep_occupational_exams_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Representante Legal."
            end    
        end
    end    

    def firmar_adv
        @occupational_exam = OccupationalExam.find_by(id: params[:id].to_i)
        if params[:format].to_i == 2
            if  @occupational_exam.user_adviser_sst.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_adv_occupational_exams_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Asesor en SST."
            end    
        end
    end    

    def firmar_res
        @occupational_exam = OccupationalExam.find_by(id: params[:id].to_i)
        if params[:format].to_i == 3
            if  @occupational_exam.user_responsible_sst.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_res_occupational_exams_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Responsable en SST."
            end    
        end
    end    

    private

    def occupational_exam_params
        params.require(:occupational_exam).permit(:user_legal_representative, :user_adviser_sst, 
        :user_responsible_sst, :entity_id, :version, :code, :date_create, :date_update, :date_firm_legal_representative, :date_firm_adviser_sst, 
        :date_firm_responsible_sst, :firm_legal_representative, :firm_adviser_sst, :firm_responsible_sst)
    end 

end  
