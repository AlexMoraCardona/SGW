class FormatActionsController < ApplicationController
    def index
        if params[:entity_id].present?
            @entity = Entity.find(params[:entity_id])
            @format_actions = FormatAction.where(entity_id: @entity.id).order(:date_format) if @entity.id.present?
        else    
            if  Current.user && Current.user.level == 1
                @entities = Entity.all
                @format_actions = FormatAction.all
            else
                redirect_to new_session_path, alert: t('common.not_logged_in')  
                session.delete(:user_id)    
            end           
        end 
    end    

    def new
      @format_action = FormatAction.new 
      @entity = Entity.find(params[:entity_id].to_i) if params[:entity_id].present? 
    end    

    def create
        @format_action  = FormatAction.new(format_action_params)
        if @format_action.save then
            redirect_to format_actions_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @format_action = FormatAction.find(params[:id])
        @entity = Entity.find(@format_action.entity_id)
    end
    
    def update
        @format_action = FormatAction.find(params[:id])
        if @format_action.update(format_action_params)
            redirect_to format_actions_path, notice: 'Formato actualizado correctamente'
        else
            render :edit, format_actions: :unprocessable_entity
        end         
    end  
    
    def destroy
        @format_action = FormatAction.find(params[:id])
        @format_action.destroy
        redirect_to format_actions_path, notice: 'Formato borrado correctamente', format_action: :see_other
    end    

    def show
        @template = Template.where("format_number = ? and document_vigente = ?",68,1).last  
        @format_action = FormatAction.find(params[:id])
        @entity  = Entity.find(@format_action.entity_id) if @format_action.present?

        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Evaluacion.xlsx"'
            }
        end    
    end 
    
    def format_action_pdf
        @template = Template.where("format_number = ? and document_vigente = ?",68,1).last  
        @format_action = FormatAction.find(params[:id])
        @entity  = Entity.find(@format_action.entity_id) if @format_action.present?

        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'format_action_pdf',
                margin: {top: 10, bottom: 10, left: 10, right: 10 },
                disable_javascript: true,
                page_size: 'letter',
                footer: {
                    right: 'Página: [page] de [topage]'
                   }                
                       } 
        end
      
    end    
    

    private

    def format_action_params
        params.require(:format_action).permit(:date_format, :description_conformity, :causes_conformity, :task, :activity, :section, :type_action, :description_action, :user_responsible, :post_responsible, :area_responsible, :date_execution, :date_verification, :efficiency_results, :action_completed, :observations, :entity_id)
    end 
end  

