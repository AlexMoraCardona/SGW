class MatrixGoalsController < ApplicationController
    def index

        if  Current.user && Current.user.level > 0 && Current.user.level < 3
            if params[:entity_id].present?
                @entity = Entity.find(params[:entity_id])
                @matrix_goals = MatrixGoal.where("entity_id = ?", params[:entity_id])
            else 
                @entities = Entity.all
            end    
        elsif Current.user && Current.user.level > 2 
            @entity = Entity.find(Current.user.entity)
            @matrix_goals = MatrixGoal.where("entity_id = ?",Current.user.entity)
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')    
            session.delete(:user_id)  
        end     

    end 
    
    def show
        @matrix_goal = MatrixGoal.find(params[:id])
        @matrix_goal_items = MatrixGoalItem.where("matrix_goal_id = ?", @matrix_goal.id) if @matrix_goal.present?
        @template = Template.where("format_number = ? and document_vigente = ?",99,1).last  
        @entity = Entity.find(@matrix_goal.entity_id) if @matrix_goal.present?
        @rep = User.find(@matrix_goal.user_representante) if  @matrix_goal.user_representante.present? && @matrix_goal.user_representante > 0
        @adv = User.find(@matrix_goal.user_asesor) if  @matrix_goal.user_asesor.present? && @matrix_goal.user_asesor > 0
        @res = User.find(@matrix_goal.user_responsible) if  @matrix_goal.user_responsible.present? && @matrix_goal.user_responsible > 0
        @report_official = ReportOfficial.where("entity_id = ? and year = ?",@entity.id,@matrix_goal.year).last if @entity.present? && @matrix_goal.present?

        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Evaluacion.xlsx"'
            }
        end    
    end  
    
    def ver_matrix_goal
        @matrix_goal = MatrixGoal.find(params[:id])
        @matrix_goal_items = MatrixGoalItem.where("matrix_goal_id = ?", @matrix_goal.id) if @matrix_goal.present?
        @template = Template.where("format_number = ? and document_vigente = ?",99,1).last  
        @entity = Entity.find(@matrix_goal.entity_id) if @matrix_goal.present?
        @rep = User.find(@matrix_goal.user_representante) if  @matrix_goal.user_representante.present? && @matrix_goal.user_representante > 0
        @adv = User.find(@matrix_goal.user_asesor) if  @matrix_goal.user_asesor.present? && @matrix_goal.user_asesor > 0
        @res = User.find(@matrix_goal.user_responsible) if  @matrix_goal.user_responsible.present? && @matrix_goal.user_responsible > 0
        @report_official = ReportOfficial.where("entity_id = ? and year = ?",@entity.id,@matrix_goal.year).last if @entity.present? && @matrix_goal.present?
        
        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'ver_matrix_goal',
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
      @matrix_goal = MatrixGoal.new  
      @template = Template.where("format_number = ? and document_vigente = ?",99,1).last  
    end    

    def create
        @matrix_goal = MatrixGoal.new(matrix_goal_params)

        if @matrix_goal.save then
            redirect_to matrix_goals_path, notice: t('.created') 
        else
            render :new, matrix_goals: :unprocessable_entity
        end    
    end    
 
    def edit
        @matrix_goal = MatrixGoal.find(params[:id])
    end
    
    def update
        @matrix_goal = MatrixGoal.find(params[:id])
        if @matrix_goal.update(matrix_goal_params)
            actualizar_fecha(@matrix_goal.id)
            redirect_to matrix_goals_path(entity_id: @matrix_goal.entity_id),  notice: 'Matriz  actualizada correctamente'
        else
            render :edit, status: :unprocessable_entity
        end         
    end   
    
    def actualizar_fecha(id)
        @matrix_goal = MatrixGoal.find(id)
        @matrix_goal.date_firm_representante = nil if @matrix_goal.firm_representante.to_i == 0
        @matrix_goal.date_firm_asesor = nil if @matrix_goal.firm_asesor.to_i == 0
        @matrix_goal.date_firm_responsible = nil if @matrix_goal.firm_responsible.to_i == 0
        @matrix_goal.save
    end       

    def destroy
        @matrix_goal = MatrixGoal.find(params[:id])
        @matrix_goal.destroy
        redirect_to matrix_goals_path, notice: 'Matriz borrada correctamente', matrix_goal: :see_other
    end    
    #pendiente corregir
    def crear_item_goal 
        @protection_elements = ProtectionElement.where("(entity = ? or entity = ?) and state_protection = ?",0,Current.user.entity,1)
        @matrix_goal_item = MatrixGoalItem.new  
        @cant = 0
        @matrix_goal_items = MatrixGoalItem.where("matrix_goal_id = ?", params[:id]) if params[:id].present?
        @cant = @matrix_goal_items.count if @matrix_goal_items.present?
        @cant = @cant + 1 
    end    

    def firmar_rep_goal 
        @matrix_goal = MatrixGoal.find_by(id: params[:id].to_i)
        if params[:format].to_i == 1
            if  @matrix_goal.user_representante.to_i == Current.user.id.to_i 
                redirect_to firmar_rep_goal_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Representante Legal."
            end    
        end
    end    

    def firmar_adv_goal
        @matrix_goal = MatrixGoal.find_by(id: params[:id].to_i)
        if params[:format].to_i == 2
            if  @matrix_goal.user_asesor.to_i == Current.user.id.to_i 
                redirect_to firmar_adv_goal_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Asesor en SST."
            end    
        end
    end    

    def firmar_res_goal
        @matrix_goal = MatrixGoal.find_by(id: params[:id].to_i)
        if params[:format].to_i == 3
            if  @matrix_goal.user_responsible.to_i == Current.user.id.to_i 
                redirect_to firmar_res_goal_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Responsable en SST."
            end    
        end
    end    

    private

    def matrix_goal_params
        params.require(:matrix_goal).permit(:date_unsafe, :user_representante, 
        :user_responsible, :user_asesor, :date_firm_representante, 
        :date_firm_responsible, :date_firm_asesor, :firm_representante, 
        :firm_responsible, :firm_asesor, :year, :entity_id)
    end 

end   

      