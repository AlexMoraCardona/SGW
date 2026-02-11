class AllowExamsController < ApplicationController
    def index
        if  Current.user && Current.user.level > 0 && Current.user.level < 3
            @allow_exams = AllowExam.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')   
             session.delete(:user_id)   
         end           
         
    end    

    def new
      @allow_exam = AllowExam.new  
    end    

    def create
        @allow_exam = AllowExam.new(allow_exam_params)
        @adm_exam = AdmExam.find(@allow_exam.adm_exam_id)  if @allow_exam.present?
        @allow_exam.name_exam = @adm_exam.description if @adm_exam.present? 
         
        if @allow_exam.save then
            redirect_to allow_exams_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @allow_exam = AllowExam.find(params[:id])
        @user_cites = ''
        vector = @allow_exam.user_cites
        cant = 0
        if vector.present?
            nvector = vector.gsub('"', '')
            nvector = nvector.gsub('[', '')
            nvector = nvector.gsub(']', '')        
            fvector = nvector.split(',')
            cant = fvector.count
        end    
        n = 0
        @nom_usuarios = ''
        while n < cant
            usu = User.find(fvector[n])
            if usu.present?
                @nom_usuarios =   @nom_usuarios + ', ' + usu.name 
            end  
            n = n + 1
        end      
    end
    
    def update
        @allow_exam = AllowExam.find(params[:id])
        if @allow_exam.update(allow_exam_params)
            redirect_to allow_exams_path, notice: 'Autorización actualizada correctamente'
        else
            render :edit, allow_exams: :unprocessable_entity
        end         
    end    

    def destroy
        @allow_exam = AllowExam.find(params[:id])
        @allow_exam.destroy
        redirect_to allow_exams_path, notice: 'Autorización borrada correctamente', allow_exam: :see_other
    end  
    
    def seleccionar_usuarios_examen
            @allow_exam = AllowExam.find(params[:id])
            @users = User.where("entity = ? or level = ?", @allow_exam.entity_id, 1)
    end 

    def citar_usuarios_examen
        vector = params[:ids] 
        n = 0
        n = params[:ids].count if params[:ids].present?
        allow_exam_id = params[:id].to_i
        allow_exam = AllowExam.find(allow_exam_id)
        allow_exam.user_cites = params[:ids]
        allow_exam.update(allow_exam_cites_params)

        if n > 0

            AllowExam.crear_citar(n, allow_exam_id, vector)
            redirect_to allow_exams_path, notice: 'Citación creada correctamente', calendar: :see_other
        else
            redirect_to allow_exams_path, status: :unprocessable_entity, alert: 'No se seleccionó ningun usuario.' 
        end    
    end

    private

    def allow_exam_params
        params.require(:allow_exam).permit(:date_initial, :date_final, :user_id, 
        :adm_exam_id, :entity_id, :name_exam, :description, :user_cites)
    end 

    def allow_exam_cites_params
        params.permit(:user_cites)
    end 

end  

