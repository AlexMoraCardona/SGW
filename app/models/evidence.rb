class Evidence < ApplicationRecord
    belongs_to :template
    belongs_to :entity
    belongs_to :evaluation_rule_detail
    has_many :firms
    has_many :participants
    has_rich_text :compliances
    has_many_attached :evi_files

    def self.buscar_ciclophva(ciclo)
        entity = Entity.find(Current.user.entity.to_i)
        evaluation = Evaluation.find_by(entity_id: entity.id)
        @evaluacion_rule_details = EvaluationRuleDetail.where("evaluation_id = ? and cycle = ?",evaluation.id,ciclo).order(:standar_detail_item_id)
        return @evaluacion_rule_details        
    end
    
    def self.buscar_evidencias(item)
        @evidencias = Evidence.where("evaluation_rule_detail_id = ?",item).order(date: :desc)
        return @evidencias
    end    


    def self.buscar_evidencias_externas(item)
        evaluacion_rule_detail = EvaluationRuleDetail.find(item)
    end    


    def self.crear_evidencia(evaluacion_rule_detail_id,template_id, entity_id)
        @evidence = Evidence.new

        @evidence.entity_id = entity_id
        @evidence.evaluation_rule_detail_id = evaluacion_rule_detail_id 
        @evidence.template_id = template_id   
        @evidence.date = Time.now
        @evidence.compliances = "<strong>METAS:</strong> <br>Enumerar cada una de las metas que se establecerán para el cumplimiento del programa de capacitación anual; ejemplo:<br/>  <br>* Capacitar al 100% de los trabajadores.<br/> <br>* Cumplir con el 80% de las actividades en el cronograma. <br/> <br>* Cumplir con lo establecido en el presupuesto. <br/> <br>* Cumplimiento de requisitos legales.<br/>  <br>* Obtener buenas respuestas en la evaluación de capacitación.<br/>    <br><strong>ESTRATEGIAS:</strong><br/> <br>Enumerar cada una de las estrategias que se establecerán para el cumplimiento del programa de capacitación anual; ejemplo:<br/>  <br>*  Evaluación de necesidades basado en matriz de peligros y riesgos.<br/> <br>* Realización de encuesta a trabajadores.<br/> <br>* Material didáctico.<br/> <br>* Modalidad de capacitación mixta: presencial y virtual.<br/> <br>* Canales de comunicación.<br/>" if @evidence.template_id == 58 || @evidence.template_id == 59 || @evidence.template_id == 60
        @evidence.compliances = "<br>* Compromiso desde la Alta Dirección, en la implementación del Sistema de Gestión de Seguridad y Salud en el Trabajo, asignando los recursos humanos, tecnológicos y financieros, garantizando el cumplimiento de los objetivos.<br/> <br>*Prevenir accidentes y enfermedades laborales, como consecuencia a la exposición de los diferentes ambientes de trabajo de todos los empleados, contratistas, proveedores y visitantes.<br/> <br>*Dar cumplimiento a todas las disposiciones legales, Decretos, leyes, Resoluciones y demás normas que sean expedidas en materia de seguridad y salud en el trabajo; y a su vez, implementarlas y ejecutarlas al interior de la Organización.<br/> <br>*Establecer el principio de la mejora continua, en todos los procesos de aseguramiento de la Seguridad y Salud en el Trabajo.<br/> <br>*Fomentar el autocuidado y participación de todo el personal en materia de Seguridad y Salud en el trabajo.<br/> <br>*Promover la salud mental, con miras a que todos los empleados que integren la organización estén en ambientes de trabajo saludables.<br/> <br>*Compromiso con la mejora continua del SG-SST.<br/>" if @evidence.template_id == 64 || @evidence.template_id == 65 || @evidence.template_id == 66
        @evidence.compliances = "<br>* Desarrollar plan de capacitación y entrenamiento para el personal incluyendo demás partes interesadas.<br/> <br>* Proporcionar los recursos necesarios para la implementación del sistema de gestión de seguridad y salud en el trabajo.<br/> <br>* Identificar los diferentes peligros y riesgos y establecer controles específicos.<br/> <br>* Investigar accidentes, incidentes.<br/> <br>* Identificar y realizar seguimiento a los requisitos legales y aplicables.<br/> <br>* Cumplir con el plan de trabajo anual según el Decreto 1072 de 2015 Y mejora continua de este.<br/>" if @evidence.template_id == 67 || @evidence.template_id == 68 || @evidence.template_id == 69
        @evidence.compliances = "<br>* Examen médico ocupacional.<br/> <br>* Higiene postural.<br/> <br>* Pausas activas.<br/> <br>* Realización de pruebas complementarias.<br/> <br>* Remitir a EPS.<br/> <br>* Uso de elementos de protección personal.<br/> <br>* Continuar manejo médico<br/>" if @evidence.template_id == 115 || @evidence.template_id == 116 || @evidence.template_id == 117
        @evidence.compliances = "<br>* Asesoría externa SST.<br>* Insumos tecnológicos, papelería.<br>* Recarga de extintores.<br>* Salario personal SST (4 horas semanales).<br>* Exámenes médicos ocupacionales (ingreso, periódicos, retiro).<br>* Elementos botiquín. <br>* Mantenimiento instalaciones y equipos.<br/>" if @evidence.template_id == 25 || @evidence.template_id == 26 || @evidence.template_id == 27
  
        if @evidence.template.format_number == 51 then
                    @texto = @texto.to_s + "<br>"
                    @texto = @texto.to_s + '<div class="row text-center"><strong>PROPUESTAS GENERALES DE INTERVENCIÓN</strong></div>'
                    @texto = @texto.to_s + "<br>"
                    @texto = @texto.to_s + "Las propuestas de intervención están orientadas a brindar recomendaciones
sobre las condiciones de seguridad que se deben tener en relación con todos los
aspectos por mejorar, observados en el recorrido de inspección."
                    @texto = @texto.to_s + "<br>"
                    @texto = @texto.to_s + "Adicional a la propuesta emitida en cada uno de los hallazgos, se dan recomendaciones generales para tener en cuenta con la finalidad de mejorar espacios de trabajo y propiciar la ejecución de tareas de manera segura."
                    @evidence.compliances = @texto
        end


        if @evidence.save then
            Firm.crear_firmas(@evidence.id)
            Participant.crear_participantes(@evidence.id)
        else
            render :edit, status: :unprocessable_entity
        end    
    end  

    def self.buscar_una_evidencia(item)
        @evidencia = Evidence.find_by(id: item.to_i)
        return @evidencia
    end 

end
