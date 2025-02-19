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
                session.delete(:user_id)     
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
                session.delete(:user_id)     
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
                session.delete(:user_id)     
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
                session.delete(:user_id)   
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
                session.delete(:user_id)     
            end
        end  
    end      
    
    def graficos 
        @year = Time.now.year  
        @entity = Entity.find(params[:id])
        @report_official = ReportOfficial.where('entity_id = ? and year = ?', @entity.id, @year).order(:month) if @entity.present?
        @report_officialtodo = ReportOfficial.where('entity_id = ?', @entity.id).order(:month) if @entity.present?
        @events = Event.where('entity_id = ?', @entity.id) if @entity.present?
        calculo_frecuencia_accidentalidad(@report_official, @report_officialtodo)
        calculo_severidad_accidentalidad(@report_official, @report_officialtodo)
        calculo_ausentismo(@report_official, @report_officialtodo)
        calculo_prevalencia(@report_official)
        calculo_incidencia(@report_official)
        calculo_proporcion(@report_official)
        calculo_peligrosriesgos(@entity)
        calculo_coberturacapacitaciones(@entity)
        calculo_trabajadorescapacitados(@entity)
        calculo_autoevaluacion(@entity)
        calculo_peligroriesgoanual(@entity)
        calculo_acapamanual(@entity)
        calculo_cumlegalanual(@entity)
        calculo_plantrabajoanual(@entity)
        
        
    end

    def graficos_pdf 
        @year = Time.now.year  
        @entity = Entity.find(params[:id])
        @report_official = ReportOfficial.where('entity_id = ? and year = ?', @entity.id, @year).order("year desc,month desc") if @entity.present?
        @events = Event.where('entity_id = ?', @entity.id) if @entity.present?
        calculo_frecuencia_accidentalidad(@report_official, @report_officialtodo)
        calculo_severidad_accidentalidad(@report_official, @report_officialtodo)
        calculo_ausentismo(@report_official, @report_officialtodo)
        calculo_prevalencia(@report_official)
        calculo_incidencia(@report_official)
        calculo_proporcion(@report_official)
        calculo_peligrosriesgos(@entity)
        calculo_coberturacapacitaciones(@entity)
        calculo_trabajadorescapacitados(@entity)
        calculo_autoevaluacion(@entity)

        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'graficos_pdf',
                margin: {top: 10, bottom: 10, left: 10, right: 10 },
                disable_javascript: true,
                page_size: 'letter',
                javascript_delay: 3000,
                window_status: "FLAG_FOR_PDF",
                image_quality: 100,
                background: true,
                disable_smart_shrinking: false,                
                footer: {
                    right: 'Página: [page] de [topage]'
                   }                
                       } 
        end


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
    
    def calculo_frecuencia_accidentalidad(report_official, report_officialtodo)
        @indicador_frecuencia_accidentalidad = Indicator.find(1)
        @datos_frecuencia_accidentalidadañog = []
        @datos_frecuencia_accidentalidadg = []
        @datos_frecuencia_accidentalidadaño = []
        @datos_frecuencia_accidentalidad = []
        @datos_año_frecuencia_accidentalidad = 0
        @datos_mes_frecuencia_accidentalidad = 0
        inter = ""

        if report_officialtodo.present?
            report_officialtodo.group_by(&:year).each  do |item, det|
                det.each do |d|
                    if item == @year
                        @datos_mes_frecuencia_accidentalidad += 1
                        fecha = Calendar.label_month(d.month.to_i).to_s + " " + item.to_s  
                        inter = fecha + ": Por cada 100 trabajadores en " + @entity.business_name + ", se presentan " + d.total_work_accidents.to_s + " Accidentes de Trabajo en el año."
                        @datos_frecuencia_accidentalidad.push([@year, fecha, d.total_work_accidents.to_i, d.total_officials.to_i, d.frecuencia_accidentalidad, inter]) 
                        @datos_frecuencia_accidentalidadg.push([fecha, d.frecuencia_accidentalidad.to_f]) 
                    else
                        if d.month == 12
                            @datos_año_frecuencia_accidentalidad += 1
                            fecha = Calendar.label_month(d.month.to_i).to_s + " " + item.to_s  
                            inter = fecha + ": Por cada 100 trabajadores en " + @entity.business_name + ", se presentan " + d.total_work_accidents.to_s + " Accidentes de Trabajo en el año."
                            @datos_frecuencia_accidentalidadaño.push([@year, fecha, d.total_work_accidents.to_i, d.total_officials.to_i, d.frecuencia_accidentalidad, inter]) 
                            @datos_frecuencia_accidentalidadañog.push([item, d.frecuencia_accidentalidad.to_f]) 
                        end    
                    end    
                end 
            end
        end
    end

    def calculo_severidad_accidentalidad(report_official, report_officialtodo)
        @indicador_severidad_accidentalidad = Indicator.find(2)
        @datos_severidad_accidentalidadañog = []
        @datos_severidad_accidentalidadg = []
        @datos_severidad_accidentalidadaño = []
        @datos_severidad_accidentalidad = []
        @datos_año_severidad_accidentalidad = 0
        @datos_mes_severidad_accidentalidad = 0
        inter = ""

        if report_officialtodo.present?
            report_officialtodo.group_by(&:year).each  do |item, det|
                det.each do |d|
                    if item == @year
                        @datos_mes_severidad_accidentalidad += 1
                        fecha = Calendar.label_month(d.month.to_i).to_s + " " + item.to_s  
                        inter = fecha + ": En " + @entity.business_name + ", por cada cien (100) trabajadores que laboran en el mes se perdieron " + d.total_days_severidad_accidents.to_s + " días por AT."
                        @datos_severidad_accidentalidad.push([@year, fecha, d.total_days_severidad_accidents.to_i, d.total_officials.to_i, d.severidad_accidentalidad, inter]) 
                        @datos_severidad_accidentalidadg.push([fecha, d.severidad_accidentalidad.to_f]) 
                    else
                        if d.month == 12
                            @datos_año_severidad_accidentalidad += 1
                            fecha = Calendar.label_month(d.month.to_i).to_s + " " + item.to_s  
                            inter = fecha + ": En " + @entity.business_name + ", por cada cien (100) trabajadores que laboran en el mes se perdieron " + d.total_days_severidad_accidents.to_s + " días por AT."
                            @datos_severidad_accidentalidadaño.push([@year, fecha, d.total_days_severidad_accidents.to_i, d.total_officials.to_i, d.severidad_accidentalidad, inter]) 
                            @datos_severidad_accidentalidadañog.push([item, d.severidad_accidentalidad.to_f]) 
                        end    
                    end    
                end 
            end
        end
    end

    def calculo_ausentismo(report_official, report_officialtodo)
        @indicador_ausentismo = Indicator.find(6)
        @datos_ausentismoañog = []
        @datos_ausentismog = []
        @datos_ausentismoaño = []
        @datos_ausentismo = []
        @datos_año_ausentismo = 0
        @datos_mes_ausentismo = 0
        inter = ""

        if report_officialtodo.present?
            report_officialtodo.group_by(&:year).each  do |item, det|
                sumadiasincapacidad = 0
                sumadiaslaborales = 0
                det.each do |d|
                    if item == @year
                        @datos_mes_ausentismo += 1
                        fecha = Calendar.label_month(d.month.to_i).to_s + " " + item.to_s  
                        inter = fecha + ": En " + @entity.business_name + ", se presentó el " + d.ausentismo_causa_medica.to_s + "% de días de ausentismo por incapacidad médicas laboral o común."
                        @datos_ausentismo.push([@year, fecha, d.total_days_absenteeism.to_i, (d.working_days_month * d.total_officials).to_i, d.ausentismo_causa_medica.to_f, inter]) 
                        @datos_ausentismog.push([fecha, d.ausentismo_causa_medica.to_f]) 
                    else
                        sumadiasincapacidad +=  d.total_days_absenteeism
                        sumadiaslaborales += (d.working_days_month * d.total_officials)
                    end    
                end 

                if sumadiaslaborales > 0
                    @datos_año_ausentismo += 1
                    fecha = "Diciembre" + " " + item.to_s  
                    inter = fecha + ": En " + @entity.business_name + ", se presentó el " + (((sumadiasincapacidad.to_f / sumadiaslaborales.to_f) * 100).round(2)).to_s + "% de días de ausentismo por incapacidad médicas laboral o común."
                    @datos_ausentismoañog.push([item, (((sumadiasincapacidad.to_f / sumadiaslaborales.to_f) * 100)).round(2)]) 
                    @datos_ausentismoaño.push([fecha, item, sumadiasincapacidad.to_i, sumadiaslaborales.to_i, (((sumadiasincapacidad.to_f / sumadiaslaborales.to_f) * 100)).round(2), inter]) 
                end    

            end
        end
    end

    def calculo_prevalencia(report_official)
        @indicador_prevalencia = Indicator.find(4)
        @datos_prevalencia = []
        report_official.each do |rep| 
            fecha = Calendar.label_month(rep.month).to_s
            @datos_prevalencia.push([fecha, rep.prevalencia_enfermedad_laboral.to_i]) 
        end
    end

    def calculo_incidencia(report_official)
        @indicador_incidencia = Indicator.find(5)
        @datos_incidencia = []
        report_official.each do |rep| 
            fecha = Calendar.label_month(rep.month).to_s
            @datos_incidencia.push([fecha, rep.incidencia_enfermedad_laboral.to_i]) 
        end
    end

    def calculo_proporcion(report_official)
        @indicador_proporcion = Indicator.find(3)
        @datos_proporcion = []
        report_official.each do |rep| 
            fecha = Calendar.label_month(rep.month).to_s
            @datos_proporcion.push([fecha, rep.proporcion_accidentes_mortales.to_f]) 
        end
    end

    def calculo_peligrosriesgos(entity)
        @indicador_peligrosyriesgos = Indicator.find(7)
        @matrix_danger_risks = MatrixDangerRisk.find_by(entity_id: entity.id) if entity.present?
        @matrix_danger_items = MatrixDangerItem.where('matrix_danger_risk_id = ?', @matrix_danger_risks.id) if @matrix_danger_risks.present?
        @indicador_peligrosriesgos = 0
        @totalpeligrosriesgos = 0
        @interpeligrosriesgos = 0
        @datos_peligrosriesgos = []
        if @matrix_danger_items.present? 
            @matrix_danger_items.each do |rep| 
                @totalpeligrosriesgos += 1
                if rep.danger_intervened == 1 then
                    @interpeligrosriesgos += 1
                end    
            end
        end    
        @indicador_peligrosriesgos = (@interpeligrosriesgos * 100)/ @totalpeligrosriesgos if @totalpeligrosriesgos > 0
        @datos_peligrosriesgos.push([@interpeligrosriesgos, @indicador_peligrosriesgos]) 

    end

    def calculo_coberturacapacitaciones(entity)
        @indicador_coberturacapacitaciones = Indicator.find(8)
        año = Time.new.year 
        training = Training.find_by(year: año, entity_id: entity.id)
        training_items = TrainingItem.where("training_id = ?",training.id) if training.present?
        @total_coberturacapacitaciones = training_items.count if training_items.present?
        cant = 0
        @datos_coberturacapacitaciones = []
        if training_items.present?
            training_items.each  do |det|
                cant += 1 if det.state_cap == 1
            end
        end         
        por = ((cant.to_f / @total_coberturacapacitaciones.to_f) * 100).round(2).to_f if   @total_coberturacapacitaciones.to_f > 0

        @datos_coberturacapacitaciones.push([cant, por.to_f])
    end

    def calculo_trabajadorescapacitados(entity)
        @indicador_trabajadorescapacitados = Indicator.find(9)
        año = Time.new.year 
        training = Training.find_by(year: año, entity_id: entity.id)
        training_items = TrainingItem.where("training_id = ?",training.id) if training.present?
        @total_trabajadores = 0
        @total_trabajadoresc = 0

        @datos_trabajadorescapacitados = []
        if training_items.present?
            training_items.each  do |det|
                @total_trabajadores += det.cant_emple_cap if det.state_cap != 2
                @total_trabajadoresc += det.cant_cap if det.state_cap == 1
            end     
        end    
        por = ((@total_trabajadoresc.to_f / @total_trabajadores.to_f) * 100).round(2).to_f if   @total_trabajadores.to_f > 0

        @datos_trabajadorescapacitados.push([@total_trabajadoresc, por.to_f])
    end

    def calculo_autoevaluacion(entity)
        @indicador_autoevaluacion = Indicator.find(10)
        año = Time.new.year 
        @cant_eva = 0
        history_evaluations = HistoryEvaluation.where("entity_id = ?", entity.id) if entity.present?
        @cant_eva =    history_evaluations.count if  history_evaluations.present?
        
        @datos_autoevaluaciones = []
        @datos_evaluacion = []
        history_evaluations.each  do |det|

            @total_items = det.completed_items + det.unfulfilled_items + det.not_apply_items 
            @inter = det.date_history_evaluation.to_s + ": En " + entity.business_name.to_s + " se cumplió con " + det.completed_items.to_s + " de " + @total_items.to_s + " estándares requeridos según la evaluación inicial."
            @datos_autoevaluaciones.push([det.date_history_evaluation, @total_items, det.completed_items ,det.percentage, det.expected_goald, @inter ])
            @datos_evaluacion.push([det.date_history_evaluation, det.percentage ])
        end     
    end

    def calculo_peligroriesgoanual(entity)
        @indicador_peligroriesgoanual = Indicator.find(11)
        año = Time.new.year 
        @cant_peligroriesgoanual = 0
        matrix_danger_risks_anual = MatrixDangerRisk.find_by(entity_id: entity.id) if entity.present?
        matrix_danger_risks_anual_items = MatrixDangerItem.where("matrix_danger_risk_id = ?", matrix_danger_risks_anual.id).order(:year) if matrix_danger_risks_anual.present?
        
        @datos_matrizdangerriskitems = []
        @datos_matrizdangerriskitemsgrafico = []
        @total_matrizdangerriskitems = 0
        if matrix_danger_risks_anual_items.present? then
            matrix_danger_risks_anual_items.group_by(&:year).each  do |item, det|
                cant = 0
                cantg = 0
                det.each do |d|
                   cant += 1 
                   cantg += 1 if d.danger_intervened == 1 
                end 
                @total_matrizdangerriskitems += 1  
                por = ((cantg.to_f / cant.to_f) * 100).round(2) if cant > 0
                @inter = "" 
                @inter = item.to_s + ": En " + entity.business_name.to_s + " se intervinieron " + cantg.to_s + " peligros/riesgos de " + cant.to_s + " peligros/riesgos identificados."
                @datos_matrizdangerriskitems.push([item, cant, cantg, por.to_s, @inter]) 
                @datos_matrizdangerriskitemsgrafico.push([item, por]) 
            end
    
        end    
    end


    def calculo_acapamanual(entity)
        @indicador_acapamanual = Indicator.find(12)
        año = Time.new.year 

        matrix_corrective_action_anual = MatrixCorrectiveAction.find_by(entity_id: entity.id) if entity.present?
        matrix_action_anual_items =  MatrixActionItem.where("matrix_corrective_action_id = ?", matrix_corrective_action_anual.id).order(:year) if matrix_corrective_action_anual.present?
        
        @datos_matrizacapamanual = []
        @datos_matrizacapamanualitemsgrafico = []
        @total_matrizacapamanualitems = 0
        if matrix_action_anual_items.present? then
            matrix_action_anual_items.group_by(&:year).each  do |item, det|
                cant = 0
                cantg = 0
                det.each do |d|
                   cant += 1 
                   cantg += 1 if d.state_actions == 1 
                end 
                @total_matrizacapamanualitems += 1  
                por = ((cantg.to_f / cant.to_f) * 100).round(2) if cant > 0
                @inter = "" 
                @inter = item.to_s + ": En " + entity.business_name.to_s + " se ejecutaron " + cantg.to_s + " acciones (AP, AC, AM) de " + cant.to_s + " acciones identificadas."
                @datos_matrizacapamanual.push([item, cant, cantg, por.to_s, @inter]) 
                @datos_matrizacapamanualitemsgrafico.push([item, por]) 
            end
    
        end    
    end

    def calculo_cumlegalanual(entity)
        @indicador_cumlegalanual = Indicator.find(13)
        año = Time.new.year 
    
        matrix_legal_anual = MatrixLegal.find_by(entity_id: entity.id) if entity.present?
        matrix_legal_anual_items =  MatrixLegalItem.where("matrix_legal_id = ? and apply = ?", matrix_legal_anual.id, 1).order(:year) if matrix_legal_anual.present?
        
        @datos_matrizlegalanual = []
        @datos_matrizalegalitemsgrafico = []
        @total_matrizlegalanualitems = 0
        if matrix_legal_anual_items.present? then
            matrix_legal_anual_items.group_by(&:year).each  do |item, det|
                cant = 0
                cantg = 0
                det.each do |d|
                   cant += 1 
                   cantg += 1 if d.meets == 2 
                end 
                @total_matrizlegalanualitems += 1  
                por = ((cantg.to_f / cant.to_f) * 100).round(2) if cant > 0
                @inter = "" 
                @inter = item.to_s + ": En " + entity.business_name.to_s + " se cumplió con " + cantg.to_s + " requisitos legales, de " + cant.to_s + " requisitos aplicables."
                @datos_matrizlegalanual.push([item, cant, cantg, por.to_s, @inter]) 
                @datos_matrizalegalitemsgrafico.push([item, por]) 
            end
    
        end    
    end
    
    def calculo_plantrabajoanual(entity)
        @indicador_plantrabajoanual = Indicator.find(14)
        año = Time.new.year 
        @cant_plan = 0
        annual_work_plans = AnnualWorkPlan.where("entity_id = ?", entity.id).order(:year) if entity.present?
        @cant_plan =    annual_work_plans.count if  annual_work_plans.present?
        
        @datos_plantrabajoanual = []
        @datos_plantrabajoanualgrafico = []
        annual_work_plans.each  do |det|
            annual_work_plan_items = AnnualWorkPlanItem.where("annual_work_plan_id = ?", det.id) 
            total_items = 0
            cumple_items = 0
            por = 0 
            inter = ""
            if annual_work_plan_items.present?
                annual_work_plan_items.each do |item|
                    total_items += 1
                    cumple_items += 1 if item.earring == 1    
                end    
            end
            por = ((cumple_items.to_f / total_items.to_f) * 100).round(2) if total_items > 0
            inter = det.year.to_s + ": En " + entity.business_name.to_s + " se ejecutarón " + cumple_items.to_s + " de " + total_items.to_s + " actividades programadas en el plan anual de trabajo."
            @datos_plantrabajoanual.push([det.year, total_items, cumple_items, por, inter])
            @datos_plantrabajoanualgrafico.push([det.year, por ])
        end     
    end


end 