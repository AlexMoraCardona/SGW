class IndicadoresController < ApplicationController

    def index
         
    end
    
    def resultado
        if  Current.user && Current.user.level == 1
            @entities = Entity.all
            @anos=[2025,2024,2023,2022,2021]
        else
            if Current.user && Current.user.level > 1
                @entities = Entity.where(id: Current.user.entity)
                @anos=[2025,2024,2023,2022,2021]
            else  
                redirect_to new_session_path, alert: t('common.not_logged_in')       
            end
        end        
    end  

    def resultadompr
        if  Current.user && Current.user.level == 1
            @entities = Entity.all
        else
            if Current.user && Current.user.level > 1
                @entities = Entity.where(id: Current.user.entity)
            else  
                redirect_to new_session_path, alert: t('common.not_logged_in')       
            end
        end        
    end      

    def resultadoml
        if  Current.user && Current.user.level == 1
            @entities = Entity.all
        else
            if Current.user && Current.user.level > 1
                @entities = Entity.where(id: Current.user.entity)
            else  
                redirect_to new_session_path, alert: t('common.not_logged_in')       
            end
        end        
    end      

    def resultadoacpm
        if  Current.user && Current.user.level == 1
            @entities = Entity.all
        else
            if Current.user && Current.user.level > 1
                @entities = Entity.where(id: Current.user.entity)
            else  
                redirect_to new_session_path, alert: t('common.not_logged_in')       
            end
        end        
    end      

    def resultadompt
        if  Current.user && Current.user.level == 1
            @entities = Entity.all
            @annual_work_plans = AnnualWorkPlan.where("entity_id = ?", params[:format].to_i )  if params[:format].present?
        else
            if Current.user && Current.user.level > 1
                @entities = Entity.where(id: Current.user.entity)
                @annual_work_plans = AnnualWorkPlan.where("entity_id = ?", params[:format].to_i )  if params[:format].present?
            else  
                redirect_to new_session_path, alert: t('common.not_logged_in')       
            end
        end  
    end      
    
    def graficos 
        @year = Time.now.year  
        @entity = Entity.find(params[:id])
        @report_official = ReportOfficial.where('entity_id = ? and year = ?', @entity.id, @year).order("year desc,month desc") if @entity.present?
        @events = Event.where('entity_id = ?', @entity.id) if @entity.present?
        calculo_frecuencia_accidentalidad(@report_official)
        calculo_severidad_accidentalidad(@report_official)
        calculo_ausentismo(@report_official)
        calculo_prevalencia(@report_official)
        calculo_incidencia(@report_official)
        calculo_proporcion(@report_official)
        calculo_peligrosriesgos(@entity)
        calculo_coberturacapacitaciones(@entity)
        calculo_trabajadorescapacitados(@entity)

    end

    def graficosmpr
        @matrix_danger_risk = MatrixDangerRisk.find(params[:id]) if params[:id].present?
        @entity = Entity.find(@matrix_danger_risk.entity_id) if @matrix_danger_risk.present?
        @matrix_danger_items = MatrixDangerItem.where('matrix_danger_risk_id = ?', @matrix_danger_risk.id) if @matrix_danger_risk.present?
        calculo_nivel_riesgo(@matrix_danger_items)
        calculo_tipo_riesgo(@matrix_danger_items)
        calculo_desc_tipo_riesgo(@matrix_danger_items)
    end

    def calculo_nivel_riesgo(matrix_danger_items)
        if matrix_danger_items == nil 
            @matrix_danger_risk = MatrixDangerRisk.find(params[:id]) if params[:id].present?
            matrix_danger_items = MatrixDangerItem.where('matrix_danger_risk_id = ?', @matrix_danger_risk.id) if @matrix_danger_risk.present?
            @entity = Entity.find(@matrix_danger_risk.entity_id) if @matrix_danger_risk.present?
        end 

        total = 0  
        cant = 0
        datos_nivel_riesgo = []
        nivel = ''
        matrix_danger_items.group_by(&:risk_level_interpretation).each do |niv, det|
            nivel = ''
            cant = 0
            det.each do |d|
               total += 1 
               cant += 1 
               nivel = niv  
            end    
                
            datos_nivel_riesgo.push(["No aceptable", cant]) if  niv.to_s == 'I'
            datos_nivel_riesgo.push(["Aceptable con controles", cant]) if  niv.to_s == 'II'
            datos_nivel_riesgo.push(["Mejorable", cant]) if  niv.to_s == 'III'
            datos_nivel_riesgo.push(["Aceptable", cant]) if  niv.to_s == 'IV'

        end
        @datos_nivel_riesgo =   datos_nivel_riesgo 
        @total = total
    end

    def calculo_tipo_riesgo(matrix_danger_items)
        if matrix_danger_items == nil 
            @matrix_danger_risk = MatrixDangerRisk.find(params[:id]) if params[:id].present?
            matrix_danger_items = MatrixDangerItem.where('matrix_danger_risk_id = ?', @matrix_danger_risk.id) if @matrix_danger_risk.present?
            @entity = Entity.find(@matrix_danger_risk.entity_id) if @matrix_danger_risk.present?
        end 

        total_tipo = 0  
        cant = 0
        datos_tipo_riesgo = []
        nivel = ''
        matrix_danger_items.group_by(&:clasification_danger_id).each do |niv, det|
            nivel = ''
            cant = 0
            det.each do |d|
               total_tipo += 1 
               cant += 1 
               nivel =  ClasificationDanger.buscar_name(niv)  
            end    
                
            datos_tipo_riesgo.push([nivel, cant])

        end
        @datos_tipo_riesgo =   datos_tipo_riesgo 
        @total_tipo = total_tipo
    end

    def calculo_desc_tipo_riesgo(matrix_danger_items)
        if matrix_danger_items == nil 
            @matrix_danger_risk = MatrixDangerRisk.find(params[:id]) if params[:id].present?
            matrix_danger_items = MatrixDangerItem.where('matrix_danger_risk_id = ?', @matrix_danger_risk.id) if @matrix_danger_risk.present?
            @entity = Entity.find(@matrix_danger_risk.entity_id) if @matrix_danger_risk.present?
        end 

        total_desc = 0  
        datos_desc_tipo_riesgo = []
        nivel = ''
        nivel_desc = ''
        cant = 0
        matrix_danger_items.group_by(&:clasification_danger_detail_id).each do |niv, det|
            nivel_desc = ''
            cant = 0
            det.each do |d|
               total_desc += 1
               cant += 1
               nivel = ClasificationDangerDetail.buscar_name_clasificacion(niv)
               nivel_desc = ClasificationDangerDetail.buscar_name(niv) 
               
            end
            datos_desc_tipo_riesgo.push([nivel, nivel_desc, cant])    
        end
        @datos_desc_tipo_riesgo =   datos_desc_tipo_riesgo 
        @total_desc = total_desc
    end

    def graficosml
        @matrix_legal = MatrixLegal.find(params[:id]) if params[:id].present?
        @entity = Entity.find(@matrix_legal.entity_id) if @matrix_legal.present?
        @matrix_legal_items = MatrixLegalItem.where('matrix_legal_id = ?', @matrix_legal.id).order(:meets) if @matrix_legal.present?
        calculo_cumplimiento(@matrix_legal_items)
    end

    def calculo_cumplimiento(matrix_legal_items)
        if matrix_legal_items == nil 
            @matrix_legal = MatrixLegal.find(params[:id]) if params[:id].present?
            matrix_legal_items = MatrixLegalItem.where('matrix_legal_id = ?', @matrix_legal.id).order(:meets) if @matrix_legal.present?
            @entity = Entity.find(@matrix_legal.entity_id) if @matrix_legal.present?
        end    
        total = 0  
        cant = 0
        datos_cumplimiento = []
        matrix_legal_items.group_by(&:meets).each do |niv, det|
            cant = 0
            det.each do |d|
               total += 1 
               cant += 1 
            end    
               
            datos_cumplimiento.push(["NO (0%)", cant]) if  niv.to_i == 0
            datos_cumplimiento.push(["PARCIAL (50%)", cant]) if  niv.to_i == 1
            datos_cumplimiento.push(["SI (100%)", cant]) if  niv.to_i == 2

        end
        @datos_cumplimiento =   datos_cumplimiento 
        @total = total
    end

    def graficosacpm
        @matrix_corrective_action = MatrixCorrectiveAction.find(params[:id]) if params[:id].present?
        @entity = Entity.find(@matrix_corrective_action.entity_id) if @matrix_corrective_action.present?
        @matrix_action_items = MatrixActionItem.where('matrix_corrective_action_id = ?', @matrix_corrective_action.id) if @matrix_corrective_action.present?
        calculo_accion(@matrix_action_items)
    end

    def calculo_accion(matrix_action_items)
        if matrix_action_items == nil 
            @matrix_corrective_action = MatrixCorrectiveAction.find(params[:id]) if params[:id].present?
            matrix_action_items = MatrixActionItem.where('matrix_corrective_action_id = ?', @matrix_corrective_action.id) if @matrix_corrective_action.present?
            @entity = Entity.find(@matrix_corrective_action.entity_id) if @matrix_corrective_action.present?
        end    

        total = 0  
        cant = 0
        datos_accion = []
        datos_0 = []
        datos_1 = []
        datos_2 = []
        datos_accion_generales = []

        matrix_action_items.group_by(&:type_corrective).each do |niv, det|
            cant = 0
            cant0 = 0
            cant1 = 0
            cant2 = 0
            det.each do |d|
               total += 1 
               cant += 1
               if d.state_actions.to_i == 0 then
                 cant0 += 1
               end  

               if d.state_actions.to_i == 1 then
                 cant1 += 1
               end 

               if d.state_actions.to_i == 2 then
                 cant2 += 1
               end  
            end    
               
            if niv.to_i == 0
                datos_accion.push(["ACCIONES PREVENTIVAS", cant])
                datos_0.push(["ABIERTO", cant0])
                datos_0.push(["PROCESO", cant1])
                datos_0.push(["CERRADO", cant2])
                datos_accion_generales.push(["ACCIONES PREVENTIVAS", cant, cant0, cant1, cant2])
            elsif niv.to_i == 1
                datos_accion.push(["ACCIONES DE MEJORA", cant])
                datos_1.push(["ABIERTO", cant0])
                datos_1.push(["PROCESO", cant1])
                datos_1.push(["CERRADO", cant2])
                datos_accion_generales.push(["ACCIONES DE MEJORA", cant, cant0, cant1, cant2])
            elsif niv.to_i == 2    
                datos_accion.push(["ACCIONES CORRECTIVAS", cant])
                datos_2.push(["ABIERTO", cant0])
                datos_2.push(["PROCESO", cant1])
                datos_2.push(["CERRADO", cant2])
                datos_accion_generales.push(["ACCIONES CORRECTIVAS", cant, cant0, cant1, cant2])
            end
        end
        @datos_accion =   datos_accion
        @datos_0 =   datos_0
        @datos_1 =   datos_1
        @datos_2 =   datos_2
        @total = total
        @datos_accion_generales = datos_accion_generales
    end

    def graficosmpt
        @annual_work_plan = AnnualWorkPlan.find(params[:id].to_i) if params[:id].present?
        @entity = Entity.find(@annual_work_plan.entity_id) if @annual_work_plan.present?
        @annual_work_plan_items = AnnualWorkPlanItem.where('annual_work_plan_id = ?', @annual_work_plan.id).order(:earring) if @annual_work_plan.present?

        calculo_objetivos(@annual_work_plan_items) if @annual_work_plan_items.present?

    end

    def calculo_objetivos(annual_work_plan_items) 
        if annual_work_plan_items == nil 
            @annual_work_plan = AnnualWorkPlan.find(params[:id]) if params[:id].present?
            annual_work_plan_items = AnnualWorkPlanItem.where('annual_work_plan_id = ?', @annual_work_plan.id) if @annual_work_plan.present?
            @entity = Entity.find(@annual_work_plan.entity_id) if @annual_work_plan.present?
        end    
        total = 0  
        cant = 0
        datos_objetivos = []
        annual_work_plan_items.group_by(&:earring).each  do |niv, det|
            cant = 0
            det.each do |d|
               total += 1 
               cant += 1 
            end    
            datos_objetivos.push(["Planeado", cant]) if  niv.to_i == 0
            datos_objetivos.push(["Ejecutado", cant]) if  niv.to_i == 1
        end
        @datos_objetivos =   datos_objetivos 
        @total = total
    end


    def show 
        @entity = Entity.find(params[:id])
    end    

    def consultar 
        if params[:entity_id].present?
            
            redirect_to graficos_path(params[:entity_id]) 
        else
            redirect_to resultado_path 
        end    
    end  

    def consultarmpr 
        if params[:entity_id].present?
            redirect_to graficosmpr_path(params[:entity_id]) 
        else
            redirect_to resultado_path 
        end    
    end  

    def consultarml 
        if params[:entity_id].present?
            redirect_to graficosml_path(params[:entity_id]) 
        else
            redirect_to resultado_path 
        end    
    end  

    def consultaracpm 
        if params[:entity_id].present?
            redirect_to graficosacpm_path(params[:entity_id]) 
        else
            redirect_to resultado_path 
        end    
    end  

    def consultarmpt 
        if params[:entity_id].present?
            redirect_to resultadompt_path(params[:entity_id]) 
        else
            redirect_to resultado_path 
        end    
    end  
    
    def calculo_frecuencia_accidentalidad(report_official)
        @datos_frecuencia_accidentalidad = []
        report_official.each do |rep| 
            fecha = Calendar.label_month(rep.month).to_s  
            @datos_frecuencia_accidentalidad.push([fecha, rep.frecuencia_accidentalidad.to_f]) 
        end
        @datos_frecuencia_accidentalidad.sort!
    end

    def calculo_severidad_accidentalidad(report_official)
        @datos_severidad_accidentalidad = []
        report_official.each do |rep| 
            fecha = Calendar.label_month(rep.month).to_s 
            @datos_severidad_accidentalidad.push([fecha, rep.severidad_accidentalidad.to_f]) 
        end
    end

    def calculo_ausentismo(report_official)
        @datos_ausentismo = []
        report_official.each do |rep| 
            fecha = Calendar.label_month(rep.month).to_s
            @datos_ausentismo.push([fecha, rep.ausentismo_causa_medica.to_f]) 
        end
    end

    def calculo_prevalencia(report_official)
        @datos_prevalencia = []
        report_official.each do |rep| 
            fecha = Calendar.label_month(rep.month).to_s
            @datos_prevalencia.push([fecha, rep.prevalencia_enfermedad_laboral.to_i]) 
        end
    end

    def calculo_incidencia(report_official)
        @datos_incidencia = []
        report_official.each do |rep| 
            fecha = Calendar.label_month(rep.month).to_s
            @datos_incidencia.push([fecha, rep.incidencia_enfermedad_laboral.to_i]) 
        end
    end

    def calculo_proporcion(report_official)
        @datos_proporcion = []
        report_official.each do |rep| 
            fecha = Calendar.label_month(rep.month).to_s
            @datos_proporcion.push([fecha, rep.proporcion_accidentes_mortales.to_f]) 
        end
    end

    def calculo_peligrosriesgos(entity)
        @matrix_danger_risks = MatrixDangerRisk.find_by(entity_id: entity.id) if entity.present?
        @matrix_danger_items = MatrixDangerItem.where('matrix_danger_risk_id = ?', @matrix_danger_risks.id) if @matrix_danger_risks.present?

        @totalpeligrosriesgos = 0
        @interpeligrosriesgos = 0
        @datos_peligrosriesgos = []
        @matrix_danger_items.each do |rep| 
            @totalpeligrosriesgos += 1
            if rep.danger_intervened == 1 then
                @interpeligrosriesgos += 1
            end    
        end
        @indicador_peligrosriesgos = (@interpeligrosriesgos * 100)/ @totalpeligrosriesgos
        @datos_peligrosriesgos.push([@interpeligrosriesgos, @indicador_peligrosriesgos]) 

    end

    def calculo_coberturacapacitaciones(entity)
        año = Time.new.year 
        training = Training.find_by(year: año, entity_id: entity.id)
        training_items = TrainingItem.where("training_id = ?",training.id) if training.present?
        @total_coberturacapacitaciones = training_items.count if training_items.present?
        cant = 0
        @datos_coberturacapacitaciones = []
        training_items.each  do |det|
            cant += 1 if det.state_cap == 1
        end     
        por = ((cant.to_f / @total_coberturacapacitaciones.to_f) * 100).round(2).to_f if   @total_coberturacapacitaciones.to_f > 0

        @datos_coberturacapacitaciones.push([cant, por.to_f])
    end

    def calculo_trabajadorescapacitados(entity)
        año = Time.new.year 
        training = Training.find_by(year: año, entity_id: entity.id)
        training_items = TrainingItem.where("training_id = ?",training.id) if training.present?
        @total_trabajadores = 0
        @total_trabajadoresc = 0

        @datos_trabajadorescapacitados = []
        training_items.each  do |det|
            @total_trabajadores += det.cant_emple_cap if det.state_cap != 2
            @total_trabajadoresc += det.cant_cap if det.state_cap == 1
        end     
        por = ((@total_trabajadoresc.to_f / @total_trabajadores.to_f) * 100).round(2).to_f if   @total_trabajadores.to_f > 0

        @datos_trabajadorescapacitados.push([@total_trabajadoresc, por.to_f])
    end

end 