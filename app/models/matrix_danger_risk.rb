class MatrixDangerRisk < ApplicationRecord
    belongs_to :entity
    has_many :matrix_danger_items
    
    def self.name_user(user_id)
        name = 'No encontrado'
        user =  User.find(user_id) if user_id.present?
        name = user.name if user.present?
        return  name 
    end

    def self.resumen(items)
        @total_items = 0
        @no = 0
        @parcial = 0
        @si = 0
        items.each do |item| 
            @total_items += 1 
            if item.meets.to_i == 0 ; @no += 1
            elsif item.meets.to_i == 1 ; @parcial += 1
            elsif item.meets.to_i == 2 ; @si += 1
            end
        end 
        return @total_items
    end     

    def self.label_firm(firm)
        if firm == 0 ; 'NO'
        elsif  firm == 1 ; 'SI'
        end 
    end  

    def self.total_peligros_riesgos(entity)
        matrix_danger_items = nil
        matrix_danger_risks = MatrixDangerRisk.where("entity_id = ?",entity).last if entity.present?
        matrix_danger_items = MatrixDangerItem.where('matrix_danger_risk_id = ?', matrix_danger_risks.id) if matrix_danger_risks.present?
        totalpeligros = 0

        if matrix_danger_items.present? then 
            matrix_danger_items.each do |rep| 
                totalpeligros += 1
            end
        end
        return  totalpeligros   
    end

    def self.inter_peligros_riesgos(entity)
        matrix_danger_items = nil
        matrix_danger_risks = MatrixDangerRisk.where("entity_id = ?",entity).last if entity.present?
        matrix_danger_items = MatrixDangerItem.where('matrix_danger_risk_id = ?', matrix_danger_risks.id) if matrix_danger_risks.present?

        totalpeligrosinter = 0

        if matrix_danger_items.present? then 
            matrix_danger_items.each do |rep| 
                if rep.danger_intervened == 1 then
                    totalpeligrosinter += 1
                end    
            end
        end    
        return totalpeligrosinter
    end


    def self.buscar_matrix_danger_risk(entity)
        matrix_danger_risk = MatrixDangerRisk.where("entity_id = ?",entity).last  if entity.present?
        return  matrix_danger_risk   
    end

    def self.duplicar_mpr(matrix)
        matrix_danger_risk = MatrixDangerRisk.find(matrix) if matrix.present?
        if matrix_danger_risk.present?
           duplicado = MatrixDangerRisk.new
           duplicado.version = matrix_danger_risk.version
           duplicado.code = matrix_danger_risk.code
           duplicado.entity_id = matrix_danger_risk.entity_id 
           duplicado.date_create = matrix_danger_risk.date_create
           duplicado.save
           items = MatrixDangerItem.where("matrix_danger_risk_id = ?",matrix_danger_risk.id)
            if items.present? then 
                items.each do |item| 
                    item_nuevo = MatrixDangerItem.new
                    item_nuevo.matrix_danger_risk_id = duplicado.id 
                    item_nuevo.consecutive = item.consecutive 
                    item_nuevo.year = Date.today.year  
                    item_nuevo.source_information =  item.source_information  
                    item_nuevo.activity = item.activity 
                    item_nuevo.task = item.task
                    item_nuevo.type_task = item.type_task
                    item_nuevo.origin = item.origin
                    item_nuevo.possible_effects_health = item.possible_effects_health
                    item_nuevo.possible_effects_security = item.possible_effects_security
                    item_nuevo.description_existing_control_origin = item.description_existing_control_origin
                    item_nuevo.description_existing_control_medium = item.description_existing_control_medium 
                    item_nuevo.description_existing_control_person = item.description_existing_control_person
                    item_nuevo.description_existing_control_observations = item.description_existing_control_observations 
                    item_nuevo.deficiency_level = item.deficiency_level
                    item_nuevo.exposure_level = item.exposure_level 
                    item_nuevo.probability_level = item.probability_level 
                    item_nuevo.interpretation = item.interpretation 
                    item_nuevo.consequence_level = item.consequence_level 
                    item_nuevo.level_risk_intervention = item.level_risk_intervention 
                    item_nuevo.risk_level_interpretation = item.risk_level_interpretation 
                    item_nuevo.risk_acceptability = item.risk_acceptability 
                    item_nuevo.number_exposed = item.number_exposed 
                    item_nuevo.hours_exposure = item.hours_exposure 
                    item_nuevo.worst_consequence = item.worst_consequence  
                    item_nuevo.existence_legal_requirement = item.existence_legal_requirement 
                    item_nuevo.intervention_measures_elimination = item.intervention_measures_elimination 
                    item_nuevo.intervention_measures_replacement = item.intervention_measures_replacement 
                    item_nuevo.intervention_measures_engineering_control = item.intervention_measures_engineering_control 
                    item_nuevo.intervention_measures_acsw = item.intervention_measures_acsw 
                    item_nuevo.intervention_measures_ppee = item.intervention_measures_ppee 
                    item_nuevo.responsible_implementation = item.responsible_implementation 
                    item_nuevo.type_register = item.type_register  
                    item_nuevo.proposed_date = item.proposed_date 
                    item_nuevo.implementation_date = item.implementation_date 
                    item_nuevo.follow_date = item.follow_date 
                    item_nuevo.observations =  item.observations
                    item_nuevo.clasification_danger_id = item.clasification_danger_id 
                    item_nuevo.clasification_danger_detail_id =  item.clasification_danger_detail_id
                    item_nuevo.location_id = item.location_id 
                    item_nuevo.number_exposed_contrators = item.number_exposed_contrators  
                    item_nuevo.number_exposed_totals = item.number_exposed_totals 
                    item_nuevo.danger_intervened = item.danger_intervened
                    item_nuevo.type_cargo = item.type_cargo

                    item_nuevo.save

                end
            end           
        end    
        return  matrix_danger_risk   
    end

    def self.duplicar_item(matrix_danger_item)
        nuevo_matrix_danger_item = MatrixDangerItem.new  
        cant = 0
        matrix_danger_items = MatrixDangerItem.where("matrix_danger_risk_id = ?", matrix_danger_item.matrix_danger_risk_id).order(:id) if matrix_danger_item.present?
        cant = matrix_danger_items.count if matrix_danger_items.present?
        cant = cant + 1 
        

        nuevo_matrix_danger_item.consecutive = cant 
        nuevo_matrix_danger_item.year = matrix_danger_item.year  
        nuevo_matrix_danger_item.source_information =  matrix_danger_item.source_information  
        nuevo_matrix_danger_item.activity = matrix_danger_item.activity 
        nuevo_matrix_danger_item.task = matrix_danger_item.task
        nuevo_matrix_danger_item.type_task = matrix_danger_item.type_task
        nuevo_matrix_danger_item.origin = matrix_danger_item.origin
        nuevo_matrix_danger_item.possible_effects_health = matrix_danger_item.possible_effects_health
        nuevo_matrix_danger_item.possible_effects_security = matrix_danger_item.possible_effects_security
        nuevo_matrix_danger_item.description_existing_control_origin = matrix_danger_item.description_existing_control_origin
        nuevo_matrix_danger_item.description_existing_control_medium = matrix_danger_item.description_existing_control_medium 
        nuevo_matrix_danger_item.description_existing_control_person = matrix_danger_item.description_existing_control_person
        nuevo_matrix_danger_item.description_existing_control_observations = matrix_danger_item.description_existing_control_observations 
        nuevo_matrix_danger_item.deficiency_level = matrix_danger_item.deficiency_level
        nuevo_matrix_danger_item.exposure_level = matrix_danger_item.exposure_level 
        nuevo_matrix_danger_item.probability_level = matrix_danger_item.probability_level 
        nuevo_matrix_danger_item.interpretation = matrix_danger_item.interpretation 
        nuevo_matrix_danger_item.consequence_level = matrix_danger_item.consequence_level 
        nuevo_matrix_danger_item.level_risk_intervention = matrix_danger_item.level_risk_intervention 
        nuevo_matrix_danger_item.risk_level_interpretation = matrix_danger_item.risk_level_interpretation 
        nuevo_matrix_danger_item.risk_acceptability = matrix_danger_item.risk_acceptability 
        nuevo_matrix_danger_item.number_exposed = matrix_danger_item.number_exposed 
        nuevo_matrix_danger_item.hours_exposure = matrix_danger_item.hours_exposure 
        nuevo_matrix_danger_item.worst_consequence = matrix_danger_item.worst_consequence  
        nuevo_matrix_danger_item.existence_legal_requirement = matrix_danger_item.existence_legal_requirement 
        nuevo_matrix_danger_item.intervention_measures_elimination = matrix_danger_item.intervention_measures_elimination 
        nuevo_matrix_danger_item.intervention_measures_replacement = matrix_danger_item.intervention_measures_replacement 
        nuevo_matrix_danger_item.intervention_measures_engineering_control = matrix_danger_item.intervention_measures_engineering_control 
        nuevo_matrix_danger_item.intervention_measures_acsw = matrix_danger_item.intervention_measures_acsw 
        nuevo_matrix_danger_item.intervention_measures_ppee = matrix_danger_item.intervention_measures_ppee 
        nuevo_matrix_danger_item.responsible_implementation = matrix_danger_item.responsible_implementation 
        nuevo_matrix_danger_item.type_register = matrix_danger_item.type_register  
        nuevo_matrix_danger_item.proposed_date = matrix_danger_item.proposed_date 
        nuevo_matrix_danger_item.implementation_date = matrix_danger_item.implementation_date 
        nuevo_matrix_danger_item.follow_date = matrix_danger_item.follow_date 
        nuevo_matrix_danger_item.observations =  matrix_danger_item.observations
        nuevo_matrix_danger_item.clasification_danger_id = matrix_danger_item.clasification_danger_id 
        nuevo_matrix_danger_item.clasification_danger_detail_id =  matrix_danger_item.clasification_danger_detail_id
        nuevo_matrix_danger_item.matrix_danger_risk_id = matrix_danger_item.matrix_danger_risk_id 
        nuevo_matrix_danger_item.location_id = matrix_danger_item.location_id 
        nuevo_matrix_danger_item.number_exposed_contrators = matrix_danger_item.number_exposed_contrators  
        nuevo_matrix_danger_item.number_exposed_totals = matrix_danger_item.number_exposed_totals 
        nuevo_matrix_danger_item.danger_intervened = matrix_danger_item.danger_intervened
        nuevo_matrix_danger_item.type_cargo = matrix_danger_item.type_cargo
        
        nuevo_matrix_danger_item.save

    end    

    def self.cargar_archivompr(archivo, matrix_danger_risk)
        #nuevo_matrix_danger_item = MatrixDangerItem.new  
        cant = 0
        matrix_danger_items = MatrixDangerItem.where("matrix_danger_risk_id = ?", matrix_danger_risk.id).order(:id) if matrix_danger_risk.present?
        cant = matrix_danger_items.count if matrix_danger_items.present?

        archivo.tempfile.each_line.with_index do |linea, indice|
            
             linea = linea.force_encoding("UTF-8")
             # Elimina el salto de línea
             linea = linea.chomp

             # Omitir la cabecera
             next if indice == 0
             next if linea.blank?
             # Separar por |
             columnas = linea.split("|")

             #proceso      = columnas[0]
             #actividad    = columnas[3]
             #np = columnas[14]
             #nr = columnas[16]
             #interpretacion = columnas[17] 
             #aceptabilidad = columnas[18]
             mensaje = "  *****ATENCIÓN:  Validar la clasificación del riesgo  y el detalle "        

             cant = cant + 1  
             consecutive = cant
             year = Date.today.year
             source_information = columnas[0]
             activity = columnas[3] #actividad
             type_task = dato_type_task(columnas[5]) #rutinaria 
             origin = columnas[1] #zona 
             possible_effects_health = columnas[8] #efectos   
             description_existing_control_origin = columnas[9] #controles_fuente   
             description_existing_control_medium = columnas[10] #controles_medio
             description_existing_control_person = columnas[11] #controles_trabajador
             deficiency_level = columnas[12] #nd
             exposure_level = columnas[13] #ne
             consequence_level =  columnas[15] #nc
             intervention_measures_elimination = columnas[19] #medias_intervencion
             clasification_danger_id = dato_clasification_danger(columnas[6])  #clase
             if clasification_danger_id == 0 then
                task = columnas[4] + mensaje + columnas[6] + " - " +columnas[7]#tarea
             else
                task = columnas[4] #tarea
             end   
             
             if clasification_danger_id == 0 then
                clasification_danger_detail_id = 41
             else
                clasification_danger_detail_id = dato_clasification_danger_detail(columnas[7], clasification_danger_id)  #descripcion
                if clasification_danger_detail_id == 0 then 
                    task = mensaje + columnas[6] + " - " +columnas[7] + " Tarea: " + columnas[4] #tarea
                else
                    task = columnas[4] #tarea
                end   
             end  
             
             
             clasification_danger_id = 5 if clasification_danger_id == 0 
             clasification_danger_detail_id = 41 if clasification_danger_detail_id == 0
             
             matrix_danger_risk_id = matrix_danger_risk.id
             location_id = dato_location(matrix_danger_risk.entity_id)
             type_cargo = dato_type_cargo(columnas[2], matrix_danger_risk.entity_id)
             intervention_measures_elimination = columnas[19] #Medida de intervención eliminación
             intervention_measures_replacement = columnas[20] #Medida de intervención sustitución
             intervention_measures_engineering_control = columnas[21] #Medida de intervención control de ingeniería

             # Aquí puedes guardar en la base de datos
              matrix_danger_item = MatrixDangerItem.create!(
                consecutive: consecutive,
                year: year,
                source_information: source_information,
                activity: activity,
                task: task,
                type_task: type_task, 
                origin: origin, 
                possible_effects_health: possible_effects_health,   
                description_existing_control_origin: description_existing_control_origin,   
                description_existing_control_medium: description_existing_control_medium,
                description_existing_control_person: description_existing_control_person,
                deficiency_level: deficiency_level,
                exposure_level: exposure_level,
                consequence_level: consequence_level,
                intervention_measures_elimination: intervention_measures_elimination,
                clasification_danger_detail_id: clasification_danger_detail_id,
                clasification_danger_id: clasification_danger_id,
                matrix_danger_risk_id: matrix_danger_risk_id,   
                location_id: location_id,   
                type_cargo: type_cargo,
                intervention_measures_elimination:  intervention_measures_elimination,
                intervention_measures_replacement: intervention_measures_replacement,
                intervention_measures_engineering_control: intervention_measures_engineering_control
              )
           MatrixDangerItem.calculos(matrix_danger_item.id) 
           MatrixDangerItem.adicionarinterIA(matrix_danger_item.id)
           MatrixDangerItem.adicionarposible(matrix_danger_item.id)
       end
    end   

    def self.dato_type_cargo(dato, entity)
        resultado = "No encontrado"
        company_position = CompanyPosition.where("entity_id = ? and name LIKE ?", entity,dato).first
        resultado = company_position.id if company_position.present?
        return resultado
    end    
    def self.dato_location(entity)
        dato = 0
        loca = Location.find_by(entity_id: entity)
        dato = loca.id if loca.present?
        return dato
    end    
    
    def self.dato_type_task(type_task)
        dato = 1
        dato = 0 if type_task == "SI" || type_task == "Sí" || "RUTINARIA"
        return dato 
    end  
    
    def self.dato_clasification_danger_detail(nombre, clasification_danger_id)

        dato = 0
        detail = ClasificationDangerDetail.where("name LIKE ? and clasification_danger_id = ?", nombre, clasification_danger_id).first if clasification_danger_id.present?
        dato = detail.id if detail.present?
        return dato
    end    

    def self.dato_clasification_danger(dato)
        lectura = dato.upcase if dato.present?
        clasification_danger = ClasificationDanger.find_by(name: lectura) if lectura.present?
        if clasification_danger.present? then
            resultado = clasification_danger.id
        else
            resultado = 0
        end 
        return resultado
    end    

    def self.label_deficiency_level(dato, id)
        item = MatrixDangerItem.find(id) if id.present?
        resultado = "Dato no encontrado"
        if dato.present? && item.present? 
            if dato < 2 ; resultado =  "Bajo - " + item.deficiency_level.to_s 
            elsif dato == 2 ; resultado =  "Medio - " + item.deficiency_level.to_s
            elsif dato == 6 ; resultado =  "Alto - " + item.deficiency_level.to_s
            elsif dato == 10 ; resultado =  "Muy Alto - " + item.deficiency_level.to_s
            end
        end    
        return resultado;
    end    

    def self.label_exposure_level(dato, id)
        item = MatrixDangerItem.find(id) if id.present?
        resultado = "Dato no encontrado"
        if dato.present? && item.present? 
            if dato < 2 ; resultado =  "Esporádica - " + item.exposure_level.to_s 
            elsif dato == 2 ; resultado =  "Ocasional - " + item.exposure_level.to_s
            elsif dato == 3 ; resultado =  "Frecuente - " + item.exposure_level.to_s
            elsif dato == 4 ; resultado =  "Continua - " + item.exposure_level.to_s
            end
        end    
        return resultado;
    end    

    def self.label_consequence_level(dato, id)
        item = MatrixDangerItem.find(id) if id.present?
        resultado = "Dato no encontrado"
        if dato.present? && item.present? 
            if dato < 25 ; resultado =  "Leve - " + item.consequence_level.to_s 
            elsif dato == 25 ; resultado =  "Grave - " + item.consequence_level.to_s
            elsif dato == 60 ; resultado =  "Muy Grave - " + item.consequence_level.to_s
            elsif dato == 100 ; resultado =  "Mortal o Catastrófico - " + item.consequence_level.to_s
            end
        end    
        return resultado;
    end    

end
