class WorkingConditionsController < ApplicationController
    def index
        if params[:entity_id].present?
            @entity = Entity.find(params[:entity_id])
            @working_conditions = WorkingCondition.where("entity_id = ?", params[:entity_id])
            @autorealizados = WorkingCondition.where("entity_id = ? and user_id = ?", params[:entity_id], Current.user.id)
        else    
            if  Current.user && Current.user.level == 1
                @entities = Entity.all
                @working_conditions = WorkingCondition.all
            else
                redirect_to new_session_path, alert: t('common.not_logged_in')  
                session.delete(:user_id)    
            end           
        end 
    end 
    
    def show
        @template = Template.find(172)
        @working_condition = WorkingCondition.find(params[:id])
        @working_condition_items = WorkingConditionItem.where("working_condition_id = ?", @working_condition.id).order(:clasification_danger_id) if @working_condition.present?
        @entity = Entity.find(@working_condition.entity_id)
        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Evaluacion.xlsx"'
            }
        end    
    end  
    
    def working_pdf
        @working_condition = WorkingCondition.find(params[:id])
        @working_condition_items = WorkingConditionItem.where("working_condition_id = ?", @working_condition.id) if @working_condition.present?
        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'working_pdf',
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
      @working_condition = WorkingCondition.new  
      @user = User.find(Current.user.id) if Current.user.present?
      @entity = Entity.find(params[:entity_id]) if params[:entity_id]
      @template = Template.find(172)
    end    

    def create
        @working_condition = WorkingCondition.new(working_condition_params)

        if @working_condition.save then
            crear_items(@working_condition.id)
            redirect_to detalles_working_path(@working_condition.id) 
        else
            render :new, working_conditions: :unprocessable_entity
        end    
    end    
 
    def edit
        @working_condition = WorkingCondition.find(params[:id])
    end
    
    def update
        @working_condition = WorkingCondition.find(params[:id])
        if @working_condition.update(working_condition_params)
            actualizar_fecha(@working_condition.id)
            redirect_to working_conditions_path, notice: 'Matriz  actualizada correctamente'
        else
            render :edit, status: :unprocessable_entity
        end         
    end   
    
    def actualizar_fecha(id)
        @working_condition = WorkingCondition.find(id)
        @working_condition.date_firm_user = nil if @working_condition.firm_user.to_i == 0
        @working_condition.save
    end       

    def destroy
        @working_condition = WorkingCondition.find(params[:id])
        @working_condition.destroy
        redirect_to working_conditions_path, notice: 'Matriz borrada correctamente', working_condition: :see_other
    end    

    def firmar_user 
        @working_condition = WorkingCondition.find_by(id: params[:id].to_i)
        if params[:format].to_i == 1
            if  @working_condition.user_id == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_user_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma."
            end    
        end
    end    

    def crear_items(dato)  
        @working_condition = WorkingCondition.find(dato.to_i) if dato.present?
        @clasification_danger_details = ClasificationDangerDetail.all
        
        @clasification_danger_details.each do |clasification_danger_detail|
            @working_condition_item = WorkingConditionItem.new
            @working_condition_item.clasification_danger_detail_id = clasification_danger_detail.id
            @working_condition_item.clasification_danger_id = clasification_danger_detail.clasification_danger_id
            @working_condition_item.working_condition_id = @working_condition.id
            @working_condition_item.save
        end    
    end    

    def detalles_working
        @working_condition = WorkingCondition.find(params[:id].to_i) if params[:id].to_i.present?
        @working_condition_items = WorkingConditionItem.where("working_condition_id = ?", @working_condition) if @working_condition.present?
        @clasification_danger_details = ClasificationDangerDetail.all
        @clasification_dangers = ClasificationDanger.all.order(:id)
    end  

    def reporte
        @working_conditions = WorkingCondition.where("entity_id = ?", params[:entity_id].to_i) if params[:entity_id].present?
        @working_condition_items = WorkingConditionItem.where("exposed = ?", 1) 
        @entity = Entity.find(params[:entity_id]) if params[:entity_id].present?
        if @working_conditions.present? then
            @items = []
            @working_conditions.each do |working_condition|
                if @working_condition_items.present? then
                    @working_condition_items.where("working_condition_id = ?",working_condition.id).each do |working_condition_item|
                        @items << working_condition_item  
                    end
                end        
            end
        end    
        @cantidad = @items.count
    end 

    def edit_item
        @working_condition_item = WorkingConditionItem.find(params[:id])
    end     

    

    private

    def working_condition_params
        params.require(:working_condition).permit(:date_creation, :sex, :age, :civil_status, :post, :area, :equipment_operates, :epp, 
        :epp_cuales, :control_proposal, :date_firm_user, :firm_user, :user_id, :entity_id)
    end 

end    


