class AnnualWorkPlansController < ApplicationController
    def index 
        if params[:entity_id].present?
            @entity = Entity.find(params[:entity_id])
            @annual_work_plans = AnnualWorkPlan.where("entity_id = ?", params[:entity_id])
        else    
            if  Current.user && Current.user.level > 0 && Current.user.level < 4 
                @entities = Entity.all
                @annual_work_plans = AnnualWorkPlan.all
            else
                redirect_to new_session_path, alert: t('common.not_logged_in') 
                session.delete(:user_id)     
            end           
        end 
    end  
    
    def show 
        @template = Template.where("format_number = ? and document_vigente = ?",33,1).last  
        @annual_work_plan = AnnualWorkPlan.find(params[:id])
        @annual_work_plan_items = AnnualWorkPlanItem.where("annual_work_plan_id = ?", @annual_work_plan.id) if @annual_work_plan.present?
        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Evaluacion.xlsx"'
            }
        end    

        pp
    end  
    
    def ver_plan
        @annual_work_plan = AnnualWorkPlan.find(params[:id])
        @annual_work_plan_items = AnnualWorkPlanItem.where("annual_work_plan_id = ?", @annual_work_plan.id) if @annual_work_plan.present?
        @template = Template.where("format_number = ? and document_vigente = ?",33,1).last  

        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'ver_plan',
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
      @annual_work_plan =  AnnualWorkPlan.new
      @template = Template.where("format_number = ? and document_vigente = ?",33,1).last  
    end    

    def create
        @annual_work_plan = AnnualWorkPlan.new(annual_work_plan_params)
        if @annual_work_plan.save then
            redirect_to annual_work_plans_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @annual_work_plan = AnnualWorkPlan.find(params[:id])
    end
    
    def update
        @annual_work_plan = AnnualWorkPlan.find(params[:id])
        if @annual_work_plan.update(annual_work_plan_params)
            redirect_to annual_work_plans_path, notice: 'Plan anual actualizado correctamente'
        else
            render :edit, annual_work_plans: :unprocessable_entity
        end         
    end    

    def destroy
        @annual_work_plan = AnnualWorkPlan.find(params[:id])
        @annual_work_plan.destroy
        redirect_to annual_work_plans_path, notice: 'Plan anual borrado correctamente', annual_work_plan: :see_other
    end  
    
    def crear_item_plan 
        @annual_work_plan_item = AnnualWorkPlanItem.new  
        @cant = 0
        @annual_work_plan_items = AnnualWorkPlanItem.where("annual_work_plan_id = ?", params[:id]) if params[:id].present?
        @cant = @annual_work_plan_items.count if @annual_work_plan_items.present?
        @cant = @cant + 1 
    end    

    def firmar_rep 
        @annual_work_plan = AnnualWorkPlan.find_by(id: params[:id].to_i)
        if params[:format].to_i == 1
            if  @annual_work_plan.user_legal_representative.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_rep_annual_work_plans_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Representante Legal."
            end    
        end
    end    

    def firmar_adv
        @annual_work_plan = AnnualWorkPlan.find_by(id: params[:id].to_i)
        if params[:format].to_i == 2
            if  @annual_work_plan.user_adviser_sst.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_adv_annual_work_plans_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Asesor en SST."
            end    
        end
    end    

    def firmar_res
        @annual_work_plan = AnnualWorkPlan.find_by(id: params[:id].to_i)
        if params[:format].to_i == 3
            if  @annual_work_plan.user_responsible_sst.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_res_annual_work_plans_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Responsable en SST."
            end    
        end
    end    

    private

    def annual_work_plan_params
        params.require(:annual_work_plan).permit(:year, :user_legal_representative, :user_adviser_sst, 
        :user_responsible_sst, :entity_id, :version, :code, :date_create, :date_update, :date_firm_legal_representative, :date_firm_adviser_sst, 
        :date_firm_responsible_sst, :firm_legal_representative, :firm_adviser_sst, :firm_responsible_sst)
    end 

end  
