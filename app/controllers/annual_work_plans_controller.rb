class AnnualWorkPlansController < ApplicationController
    def index 
        if  Current.user && Current.user.level > 0 && Current.user.level < 3
            if params[:entity_id].present?
                @entity = Entity.find(params[:entity_id])
                @annual_work_plans = AnnualWorkPlan.where("entity_id = ?", params[:entity_id]).order(id: :desc)
            else 
                @entities = Entity.all
            end    
        elsif Current.user && Current.user.level > 2 
            @entity = Entity.find(Current.user.entity)
            @annual_work_plans = AnnualWorkPlan.where("entity_id = ?",Current.user.entity)
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')    
            session.delete(:user_id)  
        end     
    end  
    
    def show 
        @template = Template.where("format_number = ? and document_vigente = ?",33,1).last  
        @annual_work_plan = AnnualWorkPlan.find(params[:id].to_i)
        @annual_work_plan_items = AnnualWorkPlanItem.where("annual_work_plan_id = ?", @annual_work_plan.id) if @annual_work_plan.present?
        @rep = User.find(@annual_work_plan.user_legal_representative) if  @annual_work_plan.user_legal_representative.present? && @annual_work_plan.user_legal_representative > 0
        @adv = User.find(@annual_work_plan.user_adviser_sst) if  @annual_work_plan.user_adviser_sst.present? && @annual_work_plan.user_adviser_sst > 0
        @res = User.find(@annual_work_plan.user_responsible_sst) if  @annual_work_plan.user_responsible_sst.present? && @annual_work_plan.user_responsible_sst > 0

        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Evaluacion.xlsx"'
            }
        end    
    end  
    
    def ver_plan
        @annual_work_plan = AnnualWorkPlan.find(params[:id].to_i)
        @annual_work_plan_items = AnnualWorkPlanItem.where("annual_work_plan_id = ?", @annual_work_plan.id) if @annual_work_plan.present?
        @template = Template.where("format_number = ? and document_vigente = ?",33,1).last  
        @rep = User.find(@annual_work_plan.user_legal_representative) if  @annual_work_plan.user_legal_representative.present? && @annual_work_plan.user_legal_representative > 0
        @adv = User.find(@annual_work_plan.user_adviser_sst) if  @annual_work_plan.user_adviser_sst.present? && @annual_work_plan.user_adviser_sst > 0
        @res = User.find(@annual_work_plan.user_responsible_sst) if  @annual_work_plan.user_responsible_sst.present? && @annual_work_plan.user_responsible_sst > 0

        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'ver_plan',
                margin: {top: 10, bottom: 10, left: 10, right: 10 },
                disable_javascript: true,
                page_size: 'letter',
                orientation: 'Landscape',
                zoom: 0.50,
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
        
        @annual_work_plan_item.aim = "* Evaluar el grado de cumplimiento del Sistema de Gestión Seguridad y Salud en el Trabajo del Consultorio. * Actualizar política de SST. * Actualizar matriz legal. * Reportar estándares mínimos al Ministerio de Trabajo. * Realizar inducción y reinducción del SG-SST. * Actualizar perfil sociodemográfico de todos los empleados de la empresa. * Establecer prácticas y procedimientos de bioseguridad, ante la exposición a riesgo visual. * Actualizar curso de 50 horas SST. * Actualizar matriz de peligros y riesgos. * Actualizar indicadores de gestión. * Verificar el estado de las instalaciones y equipos de emergencia. * Verificar el adecuado funcionamiento de los puestos de trabajo. * Capacitar al personal en riesgo psicosocial. * Fortalecer y sensibilizar a todo el personal en riesgo biológico. * Capacitar a todo el personal sobre tips para evitar riesgo por movimientos repetitivos. * Capacitación vigía. * Capacitar al personal en riesgo público. * Capacitar al personal en riesgo visual. * Capacitar al personal sobre riesgo cardiovascular. * Realizar auditoría interna al SG-SST. * Realizar informe de rendición de cuentas responsable y asesor externo. * Realizar revisión del SG-SST por la alta dirección." 
        @annual_work_plan_item.goal = "* Realizar evaluación del 100% de estándares aplicables del SG-SST. * Política de SST actualizada. * Ingresar a la matriz legal el 100% de requisitos legales aplicables nuevos. * Reportar el 100% de los estándares mínimos exigidos. * Realizar inducción y reinducción del SG-SST al 100 % del personal de la empresa. * Actualizar perfil sociodemográfico del 100% de empleados de la empresa. * Documentar el 100% del programa de riesgo visual. * Actualizar el 100% de cursos que se vencen este año. * Ingresar a la matriz el 100% de peligros nuevos. * Actualizar el 100% de Indicadores. * Inspección del 1oo% de las instalaciones de la empresa. * Inspeccionar el 100% de puestos de trabajo críticos de la empresa. * Capacitar al 100% del personal sobre riesgo psicosocial. * Capacitar al 100% del personal sobre riesgo biológico. * Capacitar al 100% del personal sobre riesgo por movimientos repetitivos. * Fortalecer los conocimientos del vigía . * Capacitar al 100% del personal sobre riesgo público. * Capacitar al 100% del personal sobre riesgo visual. * Capacitar al 100% del personal sobre riesgo cardiovascular. * Realizar auditoría al 100% del SG-SST. * Informe de rendición de cuentas. * Revisar el cumplimiento del SG-SST ." 
        @annual_work_plan_item.activity = "* Realizar la Evaluación inicial del SG-SST, para determinar el grado de cumplimiento del Consultorio. * Realizar reunión con alta dirección para la actualización de la política de SST. * Actualizar con la nueva normatividad la matriz legal. * Realizar el reporte de estándares minimos correspondientes al año anterior. * Realizar jornada de inducción y reinducción del SG-SST dirigida a todo el personal del Consultorio. * Actualizar el registro de información sociodemográfica de los empleados de la empresa. * Documentación Programa de Vigilancia Epidemiológica de riesgo visua. * Actualizar los cursos de 50 horas de SST de todo el personal. * Actualizar matriz de peligros y riesgos basado en eventos ocurridos durante el año anterior e identificación de nuevos peligros. * Actualizar y ajustar los indicadores del SG-SST. * Realizar inspección locativa y de recursos de emergencia. * Realizar inspección de puestos de trabajo. * Capacitación riesgo psicosocial. * Realizar capacitación a todo el personal sobre riesgo biológico. * Capacitación de riesgo por movimientos repetitivos. * Capacitación vigía. * Capacitación de riesgo público. * Capacitación riesgo visual. * Capacitación riesgo cardiovascular. * Realizar auditoría interna al SG-SST de la empresa. * Realizar informes de rendición de cuentas responsable y asesor externo. * Informe de revisión de la alta dirección." 
        @annual_work_plan_item.resource = "* Humano: Alta dirección - Asesor externo - Responsable SST - Vigía SST Tecnólogico: Computador, listados de asistencia, material educativo." 
        @annual_work_plan_item.responsible = "* Alta dirección, Asesor externo, responsable SST, Vigía, empleados." 
        @annual_work_plan_item.evidences_plan = "* Informe autoevaluación. * Política de SST. * Matriz legal. * Certificado reporte. * Listado de asistencia Inducción, registro fotográfico, evaluación. * Perfil sociodemográfico. * PVE riesgo visual. * Certificados. * Matriz de peligros y riesgos. * Ficha técnica indicadores. * Informes de inspección. * Presentación, listado de asistencia, registro fotográfico. * Presentación, listado de asistencia, evaluación, registro fotográfico. * Presentación, listado de asistencia, registro fotográfico. * Informe auditoría. * Informes rendición de cuentas. * Informe revisión por la alta dirección." 

        @cant = 0
        @annual_work_plan_items = AnnualWorkPlanItem.where("annual_work_plan_id = ?", params[:id]) if params[:id].present?
        @cant = @annual_work_plan_items.count if @annual_work_plan_items.present?
        @cant = @cant + 1 
    end    

    def firmar_rep 
        @annual_work_plan = AnnualWorkPlan.find_by(id: params[:id].to_i)
        if params[:format].to_i == 1
            if  @annual_work_plan.user_legal_representative.to_i == Current.user.id.to_i
                redirect_to firmar_rep_annual_work_plans_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Representante Legal."
            end    
        end
    end    

    def firmar_adv
        @annual_work_plan = AnnualWorkPlan.find_by(id: params[:id].to_i)
        if params[:format].to_i == 2
            if  @annual_work_plan.user_adviser_sst.to_i == Current.user.id.to_i
                redirect_to firmar_adv_annual_work_plans_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Asesor en SST."
            end    
        end
    end    

    def firmar_res
        @annual_work_plan = AnnualWorkPlan.find_by(id: params[:id].to_i)
        if params[:format].to_i == 3
            if  @annual_work_plan.user_responsible_sst.to_i == Current.user.id.to_i
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
