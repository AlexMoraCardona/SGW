class SafetyInspectionsController < ApplicationController
    def index 
        if params[:entity_id].present?
            @entity = Entity.find(params[:entity_id])
            @safety_inspections = SafetyInspection.where("entity_id = ?", params[:entity_id])
            @safety_inspection_items = SafetyInspectionItem.all.order(:id)
        else    
            if  Current.user && Current.user.level == 1
                @entities = Entity.all
                @safety_inspections = SafetyInspection.all
                @safety_inspection_items = SafetyInspectionItem.all
            else
                redirect_to new_session_path, alert: t('common.not_logged_in') 
                session.delete(:user_id)     
            end           
        end 
    end  
    
    def show 
        @template = Template.find(220)
        @safety_inspection = SafetyInspection.find(params[:id])
        @entity = Entity.find(@safety_inspection.entity_id) if @safety_inspection.present?
        @user_responsable = User.find(@safety_inspection.user_responsible)

        @safety_inspection_items = SafetyInspectionItem.where("safety_inspection_id = ?", @safety_inspection.id) if @safety_inspection.present?
        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Evaluacion.xlsx"'
            }
        end    
    end  
    
    def ver_inspeccion_pdf
        @safety_inspection = SafetyInspection.find(params[:id])
        @safety_inspection_items = SafetyInspectionItem.where("safety_inspection_id = ?", @safety_inspection.id) if @safety_inspection.present?
        @template = Template.find(220)
        @entity = Entity.find(@safety_inspection.entity_id) if @safety_inspection.present?
        @user_responsable = User.find(@safety_inspection.user_responsible) if @safety_inspection.present?

        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'ver_inspeccion',
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
      @safety_inspection =  SafetyInspection.new
      @template = Template.find(220)
    end    

    def create
        @safety_inspection = SafetyInspection.new(safety_inspection_params)
        if @safety_inspection.save then
            crear_items_inspeccion(@safety_inspection)
            redirect_to safety_inspections_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @safety_inspection = SafetyInspection.find(params[:id])
    end
    
    def update
        @safety_inspection = SafetyInspection.find(params[:id])
        if @safety_inspection.update(safety_inspection_params)
            actualizar_fecha(@safety_inspection.id)
            redirect_to safety_inspections_path(entity_id: @safety_inspection.entity_id), notice: 'Inspección actualizada correctamente'
        else
            render :edit, safety_inspections: :unprocessable_entity
        end         
    end    

    def destroy
        @safety_inspection = SafetyInspection.find(params[:id])
        @safety_inspection.destroy
        redirect_to safety_inspections_path, notice: 'Inspección borrada correctamente', safety_inspection: :see_other
    end  

    def actualizar_fecha(id)
        @safety_inspection = SafetyInspection.find(id)
        @safety_inspection.date_firm_responsible = nil if @safety_inspection.firm_responsible.to_i == 0
        @safety_inspection.save
    end      
     
    def crear_items_inspeccion(safety_inspection) 
        @situation_conditions = SituationCondition.all
        @situation_conditions.each do |situation_condition|
            @safety_inspection_item = SafetyInspectionItem.new
            @safety_inspection_item.safety_inspection_id = safety_inspection.id
            @safety_inspection_item.situation_condition_id = situation_condition.id
            @safety_inspection_item.save
        end
    end    

    def firmar_responsable_inspeccion
        @safety_inspection = SafetyInspection.find_by(id: params[:id].to_i)
        if params[:format].to_i == 2
            if  @safety_inspection.user_responsible.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_responsable_inspeccion_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Responsable."
            end    
        end
    end    

    private

    def safety_inspection_params
        params.require(:safety_inspection).permit(:date_inspection,:place_inspection, :area_inspection, :productivity_affectation, :user_responsible, :date_firm_responsible, :firm_responsible, :post_responsible, :entity_id)
    end 
end 



