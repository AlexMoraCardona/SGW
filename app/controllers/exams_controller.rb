class ExamsController < ApplicationController
    def index
        if params[:entity_id].present? && Current.user 
            @entity = Entity.find(params[:entity_id])
            @allow_exams = AllowExam.where("entity_id = ? and date_initial <= ? and date_final >= ?", params[:entity_id].to_i, Date.today, Date.today)  
            @examenes_activos = Exam.buscar_examenes(@allow_exams, Current.user.id)
        else    
            if  Current.user 
                @entities = Entity.all.order(id: :asc) if Current.user.level == 1
                @entities = Entity.find(Current.user.entity) if Current.user.level != 1 
            else
                redirect_to new_session_path, alert: t('common.not_logged_in')  
                session.delete(:user_id)    
            end           
        end
    end    

    def historia
        pppppp
        if params[:entity_id].present? && Current.user 
            @entity = Entity.find(params[:entity_id])
            @allow_exams = AllowExam.where("entity_id = ? and date_initial <= ? and date_final >= ?", params[:entity_id].to_i, Date.today, Date.today)  
        else    
            if  Current.user 
                @entities = Entity.all if Current.user.level == 1
                @entities = Entity.find(Current.user.entity) if Current.user.level != 1 
            else
                redirect_to new_session_path, alert: t('common.not_logged_in') 
                session.delete(:user_id)     
            end           
        end
    end    
    
    def show 
        if params[:entity_id].present? && Current.user 
            @entity = Entity.find(params[:entity_id].to_i)
            @adm_exams = AdmExam.all
            @users = User.where("entity = ?", params[:entity_id].to_i)
            @allow_exams = AllowExam.where("entity_id = ?", params[:entity_id].to_i)  
            @users.each do |u| 
                @exams = Exam.all.where("user_id = ?", u.id) 
            end  
        else    
            if  Current.user 
                @entities = Entity.all if Current.user.level == 1
                @entities = Entity.find(Current.user.entity) if Current.user.level != 1 
            else
                redirect_to new_session_path, alert: t('common.not_logged_in') 
                session.delete(:user_id)     
            end           
        end
    end    
    
    def new
      @exam = Exam.new  
    end    

    def create
        @exam = Exam.new(exam_params)

        if @exam.save then
            redirect_to exams_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @exam = Exam.find(params[:id])
    end
    
    def update
        @exam = Exam.find(params[:id])
        if @exam.update(exam_params)
            redirect_to exams_path, notice: 'Evaluación actualizada correctamente'
        else
            render :edit, exams: :unprocessable_entity
        end         
    end    

    def destroy
        @exam = Exam.find(params[:id])
        @exam.destroy
        redirect_to exams_path, notice: 'Evaluación borrado correctamente', exam: :see_other
    end    
 
    def repro
        @dets = Exam.detalle_realiza(params[:id].to_i, params[:format])
    end 

    def apro   
        @dets = Exam.detalle_realiza(params[:id].to_i, params[:format])
    end 
    
    def repro_det
        @det_repros = ExamDetail.where("exam_id = ?", params[:id].to_i)
    end    

    def evaluacion 
        
        @int = 0
        @allow_exam = AllowExam.find(params[:allow_exam_id].to_i) if params[:allow_exam_id].present?
        @adm_exam = AdmExam.find(@allow_exam.adm_exam_id.to_i) if @allow_exam.present?

        if @adm_exam.present? && params[:id].present? && @allow_exam.present?
            @int = Exam.where("user_id = ? and adm_exam_id = ? and allow_exam_id = ?", params[:id].to_i, @adm_exam.id.to_i, @allow_exam.id.to_i).count
        end  
        @exam = Exam.new 
        @exam.user_id =  params[:id].to_i  if params[:id].present?
        @exam.adm_exam_id =  @adm_exam.id.to_i  if @adm_exam.present?
        @exam.allow_exam_id =  @allow_exam.id.to_i  if @allow_exam.present?

        if @int < @exam.adm_exam.cant_attempts
            @exam.save
            @exam_questions = ExamQuestion.where("adm_exam_id = ?", @exam.adm_exam_id ) if @exam.adm_exam_id.present?
            @user = User.find(params[:id].to_i) if params[:id].present?
            @entity = Entity.find(@user.entity) if @user.entity.present?
            if @exam_questions.present?
    
                @exam_questions.each do |exam_question|
                    @exam_detail = ExamDetail.new
                    @exam_detail.exam_id = @exam.id if @exam.present?
                    @exam_detail.exam_question_id = exam_question.id  if @exam.present?
                    @exam_detail.correct = 0  if @exam.present?
                    @exam_detail.save
                end
            else
                redirect_to exams_path, alert: 'Error en la evaluación', exam: :see_other    
            end
        else
            redirect_to exams_path, alert: 'Sobrepasa el límite permitido de intentos', exam: :see_other    
        end    
    end

    def guardar_respuesta 
        if  params[:id].present? 
            @exam = Exam.find(params[:id].to_i)
            if @exam.present?
                @exam_details = ExamDetail.where("exam_id = ?", @exam.id)
                if @exam_details.present? 
                    i = 1
                    while i < 21
                        if i == 1 ; Exam.leerparametro(params[:"1"],@exam_details) if params[:"1"].present?
                        elsif i == 2 ; Exam.leerparametro(params[:"2"],@exam_details) if params[:"2"].present?
                        elsif i == 3 ; Exam.leerparametro(params[:"3"],@exam_details) if params[:"3"].present?
                        elsif i == 4 ; Exam.leerparametro(params[:"4"],@exam_details) if params[:"4"].present?
                        elsif i == 5 ; Exam.leerparametro(params[:"5"],@exam_details) if params[:"5"].present?
                        elsif i == 6 ; Exam.leerparametro(params[:"6"],@exam_details) if params[:"6"].present?
                        elsif i == 7 ; Exam.leerparametro(params[:"7"],@exam_details) if params[:"7"].present?
                        elsif i == 8 ; Exam.leerparametro(params[:"8"],@exam_details) if params[:"8"].present?
                        elsif i == 9 ; Exam.leerparametro(params[:"9"],@exam_details) if params[:"9"].present?
                        elsif i == 10 ; Exam.leerparametro(params[:"10"],@exam_details) if params[:"10"].present?
                        elsif i == 11 ; Exam.leerparametro(params[:"11"],@exam_details) if params[:"11"].present?
                        elsif i == 12 ; Exam.leerparametro(params[:"12"],@exam_details) if params[:"12"].present?
                        elsif i == 13 ; Exam.leerparametro(params[:"13"],@exam_details) if params[:"13"].present?
                        elsif i == 14 ; Exam.leerparametro(params[:"14"],@exam_details) if params[:"14"].present?
                        elsif i == 15 ; Exam.leerparametro(params[:"15"],@exam_details) if params[:"15"].present?
                        elsif i == 16 ; Exam.leerparametro(params[:"16"],@exam_details) if params[:"16"].present?
                        elsif i == 17 ; Exam.leerparametro(params[:"17"],@exam_details) if params[:"17"].present?
                        elsif i == 18 ; Exam.leerparametro(params[:"18"],@exam_details) if params[:"18"].present?
                        elsif i == 19 ; Exam.leerparametro(params[:"19"],@exam_details) if params[:"19"].present?
                        elsif i == 20 ; Exam.leerparametro(params[:"20"],@exam_details) if params[:"20"].present?
                        end 
                        i = i + 1
                    end
                end    
            end  
            Exam.calcular(@exam.id)
            redirect_to ver_respuesta_path(@exam.id)
        else
             redirect_to new_session_path, alert: 'No se pudo guardar la respuesta'  
             session.delete(:user_id) 
        end    
    end    

    def ver_respuesta 
        if  params[:id].present? 
            @exam = Exam.find(params[:id].to_i) if params[:id].present?
            @exam_details = ExamDetail.where("exam_id = ?", @exam.id) if @exam.present?
            @adm_exam = AdmExam.find(@exam.adm_exam_id.to_i)
            @exam_questions = ExamQuestion.where("adm_exam_id = ?", @exam.adm_exam_id ) if @exam.adm_exam_id.present?
            @user = User.find(@exam.user_id.to_i) if @exam.present?
            @entity = Entity.find(@user.entity) if @user.entity.present?
            @can_intentos = 0
            @intentos = Exam.where("user_id = ? and adm_exam_id = ? and allow_exam_id = ?", @exam.user_id.to_i, @exam.adm_exam_id.to_i, @exam.allow_exam_id.to_i).order(id: :desc)
            @can_intentos = @intentos.count
        else
            redirect_to new_session_path, alert: 'No se pudo mostrar el resultado'     
            session.delete(:user_id)  
        end    

    end  
    
    def ver_detalle
        @allow_exam = AllowExam.find(params[:id].to_i) if params[:id].present?
        @adm_exam =   AdmExam.find(@allow_exam.adm_exam_id.to_i) if @allow_exam.present?
    end  

    private

    def exam_params
        params.require(:exam).permit(:total_good, :total_bad, :final_percentage, 
        :time_exam, :adm_exam_id, :user_id, :percentage_min, :resul, :allow_exam_id)
    end 

end  
