class MatrixCorrectiveActionsController < ApplicationController
    def index
        if params[:entity_id].present?
            @entity = Entity.find(params[:entity_id])
            @matrix_corrective_action = MatrixCorrectiveAction.find_by(entity_id: params[:entity_id])
            @matrix_action_items = MatrixActionItem.where(matrix_corrective_action_id: @matrix_corrective_action.id).order(:consecutive) if @matrix_corrective_action.present?
            @total_items = 0
            @ac = 0
            @am = 0
            @ap = 0
            if @matrix_action_items.present?
                @matrix_action_items.each do |item| 
                    @total_items += 1 
                    if item.type_corrective.to_i == 0 ; @ap += 1
                    elsif item.type_corrective.to_i == 1 ; @am += 1
                    elsif item.type_corrective.to_i == 2 ; @ac += 1
                    end
                end
            end     
        else    
            if  Current.user && Current.user.level == 1
                @entities = Entity.all
                @matrix_corrective_actions = MatrixCorrectiveAction.all
            else
                redirect_to new_session_path, alert: t('common.not_logged_in')      
            end           
        end 
         
    end     

    def new
      @matrix_corrective_action = MatrixCorrectiveAction.new  
      @template = Template.find(208)
    end    

    def create
        @matrix_corrective_action = MatrixCorrectiveAction.new(matrix_corrective_action_params)

        if @matrix_corrective_action.save then
            redirect_to matrix_corrective_actions_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @matrix_corrective_action = MatrixCorrectiveAction.find(params[:id])
    end
    
    def update
        @matrix_corrective_action = MatrixCorrectiveAction.find(params[:id])
        if @matrix_corrective_action.update(matrix_corrective_action_params)
            redirect_to matrix_corrective_actions_path, notice: 'Matriz actualizada correctamente'
        else
            render :edit, matrix_corrective_actions: :unprocessable_entity
        end         
    end    

    def destroy
        @matrix_corrective_action = MatrixCorrectiveAction.find(params[:id])
        @matrix_corrective_action.destroy
        redirect_to matrix_corrective_actions_path, notice: 'Matriz borrada correctamente', matrix_corrective_action: :see_other
    end    

    def crear_item 
        @matrix_action_item = MatrixActionItem.new  
        @cant = 0
        @matrix_action_items = MatrixActionItem.where("matrix_corrective_action_id = ?", params[:id]) if params[:id].present?
        @matrix_corrective_action = MatrixCorrectiveAction.find(params[:id]) if params[:id].present?
        @locations  = Location.where("entity_id = ?", @matrix_corrective_action.entity_id) if @matrix_corrective_action.present?
        @cant = @matrix_action_items.count if @matrix_action_items.present?
        @cant = @cant + 1
    end    

    def total_items
        @matrix_action_items = MatrixActionItem.where(matrix_corrective_action_id: params[:id]).order(:consecutive) if params[:id].present?
    end    

    def show
        @matrix_corrective_action = MatrixCorrectiveAction.find_by(id: params[:id].to_i)
        @matrix_action_items = MatrixActionItem.where(matrix_corrective_action_id: params[:id].to_i).order(:consecutive)
        @locations  = Location.where("entity_id = ?", @matrix_corrective_action.entity_id) if @matrix_corrective_action.present?

    end

    def resumen_pdf
        @matrix_corrective_action = MatrixCorrectiveAction.find(params[:id])
        @matrix_action_items = MatrixActionItem.where("matrix_corrective_action_id = ?", @matrix_corrective_action.id).order(:consecutive) if @matrix_corrective_action.present?
        @entity = Entity.find(@matrix_corrective_action.entity_id)  if @matrix_corrective_action.present?
        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'resumen_pdf',
                margin: {top: 10, bottom: 10, left: 10, right: 10 },
                disable_javascript: true,
                page_size: 'letter',
                footer: {
                    right: 'Página: [page] de [topage]'
                   }                
                       } 
        end
      
    end        

    def firmar_rep 
        @matrix_corrective_action = MatrixCorrectiveAction.find_by(id: params[:id].to_i)
        if params[:format].to_i == 1
            if  @matrix_corrective_action.user_legal_representative.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_rep_matrix_corrective_actions_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Representante Legal."
            end    
        end
    end    

    def firmar_adv
        @matrix_corrective_action = MatrixCorrectiveAction.find_by(id: params[:id].to_i)
        if params[:format].to_i == 2
            if  @matrix_corrective_action.user_adviser_sst.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_adv_matrix_corrective_actions_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Asesor en SST."
            end    
        end
    end    

    def firmar_res
        @matrix_corrective_action = MatrixCorrectiveAction.find_by(id: params[:id].to_i)
        if params[:format].to_i == 3
            if  @matrix_corrective_action.user_responsible_sst.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_res_matrix_corrective_actions_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Responsable en SST."
            end    
        end
    end    

    private

    def matrix_corrective_action_params
        params.require(:matrix_corrective_action).permit(:user_legal_representative, :user_adviser_sst, 
        :user_responsible_sst, :version, :code, :entity_id, :date_create, :date_update)
    end 
end  

