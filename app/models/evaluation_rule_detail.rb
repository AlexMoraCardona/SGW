class EvaluationRuleDetail < ApplicationRecord
    has_many_attached :files
    has_many :templates

    def self.ransackable_attributes(auth_object = nil)
        ["meets", "standar_detail_item_id", "cycle", "item_nro"]
    end 

    def self.ransackable_associations(auth_object = nil)
        []
    end     


    #has_one_attached :file
    include PgSearch::Model
    pg_search_scope :search_by_id, against: :evaluation_id
    pg_search_scope :search_full_text, against: {
        evaluation_id: 'A'
    }
    belongs_to :evaluation
    belongs_to :standar_detail_item

    def label_cycle
        if evaluation_items.standar_detail_item.standar_detail.standar.cycle == 1 ; 'Planificar'
        elsif evaluation_items.standar_detail_item.standar_detail.standar.cycle == 2 ; 'Hacer'
        elsif evaluation_items.standar_detail_item.standar_detail.standar.cycle == 3 ; 'Verificar'
        elsif evaluation_items.standar_detail_item.standar_detail.standar.cycle == 4 ; 'Actuar'
        end 
    end

    
    def self.miles(valor)
        cadena = valor.to_s
        n = cadena.length
        i = 0
        separador = 0
        nuevodato = ''
        while i < n
            separador = n - i
            if separador == 4 || separador == 7 || separador == 10 || separador == 13 || separador == 16 
                nuevodato << cadena[i]
                nuevodato << "."
            else 
                nuevodato << cadena[i]
            end 
            i += 1
        end  
        return nuevodato;
    end

    def self.label_meets(dato)
        if dato == 0 ; 'NO'
        elsif dato == 1 ; 'SI'
        elsif dato == 2 ; 'NA'
        end 
    end 

    def self.label_apply(dato)
        if dato == 0 ; 'NO'
        elsif dato == 1 ; 'SI'
        end 
    end 

    def self.calculoat(ano, entidad)
        year = ano 
        entity = Entity.find(entidad)
        events = Event.where('entity_id = ?', entity.id) if entity.present?
        at = []
        i = 1
        while i < 13
            cant = 0
            events.each do |eve|
                if eve.date_new.year == year && eve.date_new.month == i  && eve.work_accident == 1 then
                    cant += 1   
                end  
            end
            mes = 'NA'
            if i == 1 ; mes = 'enero'
            elsif  i == 2 ; mes = 'febrero'
            elsif  i == 3 ; mes = 'marzo'
            elsif  i == 4 ; mes = 'abril'
            elsif  i == 5 ; mes = 'mayo'
            elsif  i == 6 ; mes = 'junio'
            elsif  i == 7 ; mes = 'julio'
            elsif  i == 8 ; mes = 'agosto'
            elsif  i == 9 ; mes = 'septiembre'
            elsif  i == 10 ; mes = 'octubre'
            elsif  i == 11 ; mes = 'noviembre'
            elsif  i == 12 ; mes ='diciembre'
            end 

            at.push([mes, cant.to_i]) 
            i = i + 1
        end   
        return at; 
    end    

    def self.calculoca(ano, entidad)
        year = ano 
        entity = Entity.find(entidad)
        events = Event.where('entity_id = ? and work_accident = ?', entity.id, 1) if entity.present?
        ca = []

        events.group_by(&:affected_body).each do |event, det|
            cant = 0
            cuerpo = 'NA'
            det.each do |d|
               if d.date_new.year == year then
                cant += 1 
                cuerpo = name_cuerpo(d.affected_body)  
               end 
            end    
            ca.push([cuerpo, cant]) if cant > 0
        end
        return ca; 
    end   

    def self.calculoel(ano, entidad)
        year = ano 
        entity = Entity.find(entidad)
        events = Event.where('entity_id = ?', entity.id) if entity.present?
        el = []
        i = 1
        while i < 13
            cant = 0
            events.each do |eve|
                if eve.date_new.year == year && eve.date_new.month == i  && eve.occupational_disease == 1 then
                    cant += 1   
                end  
            end
            mes = 'NA'
            if i == 1 ; mes = 'enero'
            elsif  i == 2 ; mes = 'febrero'
            elsif  i == 3 ; mes = 'marzo'
            elsif  i == 4 ; mes = 'abril'
            elsif  i == 5 ; mes = 'mayo'
            elsif  i == 6 ; mes = 'junio'
            elsif  i == 7 ; mes = 'julio'
            elsif  i == 8 ; mes = 'agosto'
            elsif  i == 9 ; mes = 'septiembre'
            elsif  i == 10 ; mes = 'octubre'
            elsif  i == 11 ; mes = 'noviembre'
            elsif  i == 12 ; mes ='diciembre'
            end 

            el.push([mes, cant.to_i]) 
            i = i + 1
        end   
        return el; 
    end    

    def self.calculocael(ano, entidad)
        year = ano 
        entity = Entity.find(entidad)
        events = Event.where('entity_id = ? and occupational_disease = ?', entity.id, 1) if entity.present?
        cael = []

        events.group_by(&:affected_body).each do |event, det|
            cant = 0
            cuerpo = 'NA'
            det.each do |d|
               if d.date_new.year == year then
                cant += 1 
                cuerpo = name_cuerpo(d.affected_body)  
               end 
            end    
            cael.push([cuerpo, cant]) if cant > 0
        end
        return cael; 
    end   

    
    def self.name_cuerpo(dato)
        if dato == 0 ; 'Sin clasificar'
        elsif dato == 1 ; 'Cerebro'
        elsif dato == 2 ; 'Oído (s)  externo'
        elsif dato == 3 ; 'Oído (s)  interno (incluyendo la audición)'
        elsif dato == 4 ; 'Ojo (s) (incluye nervios ópticos y visión)'
        elsif dato == 5 ; 'Párpado'
        elsif dato == 6 ; 'Mandíbula (incluyendo el mentón)'
        elsif dato == 7 ; 'Boca (incluye labios, diente, lengua, garganta y sentido del gusto)'
        elsif dato == 8 ; 'Mejilla'
        elsif dato == 9 ; 'Nariz (incluye fosas nasales, senos y sentido del olfato)'
        elsif dato == 10 ; 'Ceja'
        elsif dato == 11 ; 'Cara, partes múltiples (cualquier combinación de las partes arriba citadas)'
        elsif dato == 12 ; 'Cara, no identificada en otra parte'
        elsif dato == 13 ; 'Cuero cabelludo'
        elsif dato == 14 ; 'Cráneo (incluye solamente lesiones óseas de la bóveda y la base craneal sin compromiso cerebral'
        elsif dato == 15 ; 'Cabeza, múltiple, cualquier combinación de las partes anteriores'
        elsif dato == 16 ; 'Cabeza no identificada en otra parte'
        elsif dato == 17 ; 'Cuello (incluye columna cervical y médula espinal correspondiente)'
        elsif dato == 18 ; 'Brazo'
        elsif dato == 19 ; 'Hombro'
        elsif dato == 20 ; 'Codo'
        elsif dato == 21 ; 'Antebrazo'
        elsif dato == 22 ; 'Extremidades superiores (cualquier combinación de las partes anteriores)'
        elsif dato == 23 ; 'Extremidades superiores (arriba de la muñeca), no identificada en otra parte'
        elsif dato == 24 ; 'Muñecas'
        elsif dato == 25 ; 'Mano (excluyendo la muñeca y los dedos)'
        elsif dato == 26 ; 'Mano,  incluyendo dedos'
        elsif dato == 27 ; 'Dedo (s)'
        elsif dato == 28 ; 'Extremidades superiores, múltiples (cualquier combinación de las partes anteriores)'
        elsif dato == 29 ; 'Extremidades superiores, no identificada en otra parte'
        elsif dato == 30 ; 'Abdomen (incluye órganos internos y sus hernias)'
        elsif dato == 31 ; 'Espalda (incluye músculos de la espalda, columna, dorso lumbar, región lumbar y médula espinal)'
        elsif dato == 32 ; 'Tórax (incluye costillas, esternón y órganos internos del tórax)'
        elsif dato == 33 ; 'Caderas (incluye pelvis, órganos pélvicos y nalgas,  escroto, coxis, pubis, sacro, ilíaco y órganos genitales)'
        elsif dato == 34 ; 'Hombros (incluye axila)  región escapular,  omoplato y clavícula'
        elsif dato == 35 ; 'Tronco, múltiples (cualquier combinación de las partes anteriores)'
        elsif dato == 36 ; 'Tronco,  no identificada en otra parte'
        elsif dato == 37 ; 'Muslo'
        elsif dato == 38 ; 'Rodilla (incluye región poplítea),  corva'
        elsif dato == 39 ; 'Pierna  (entre la rodilla y el tobillo)'
        elsif dato == 40 ; 'Extremidades inferiores múltiples (cualquier combinación de las partes anteriores)'
        elsif dato == 41 ; 'Extremidades inferiores,  no identificadas en otra parte (arriba del tobillo)'
        elsif dato == 42 ; 'Tobillos'
        elsif dato == 43 ; 'Pié (excluyendo tobillo y dedos)'
        elsif dato == 44 ; 'Dedo(s) o  artejos'
        elsif dato == 45 ; 'Extremidades inferiores,  múltiples  (cualquier combinación de las partes anteriores)'
        elsif dato == 46 ; 'Extremidades inferiores no identificadas en otra parte'
        elsif dato == 47 ; 'Parte múltiples  (se aplica cuando se ha afectado más de una de las partes principales del cuerpo,  tales como,  un brazo, una pierna)'
        elsif dato == 48 ; 'Sistemas orgánicos (Se aplica cuando la totalidad de un sistema orgánico ha sido afectado, sin lesión específica en ninguna otra parte, como en el caso de intoxicación,  acción corrosiva que afecte órganos internos,  lesión de centros nerviosos, etc.  No se aplica cuando el daño en el sistema es producido por una lesión externa, que afecta una parte externa, tal como una lesión en la espalda que incluye daño a los nervios de la medula espinal)'
        elsif dato == 49 ; 'Sistema circulatorio  (corazón, sangre, arterias, venas,  etc.)'
        elsif dato == 50 ; 'Sistema digestivo'
        elsif dato == 51 ; 'Sistema excretorio (riñones, vejiga, intestinos, etc.)'
        elsif dato == 52 ; 'Sistema músculo-esquelético  (huesos, articulaciones, tendones, músculos, etc.'
        elsif dato == 53 ; 'Sistema nervioso'
        elsif dato == 54 ; 'Sistema respiratorio (pulmones, etc.)'
        elsif dato == 55 ; 'Varios sistemas orgánicos'
        elsif dato == 56 ; 'Otros sistemas orgánicos'
        elsif dato == 57 ; 'Partes del cuerpo,  no identificadas en otra parte'
        elsif dato == 58 ; 'Sin clasificar (insuficiente información para identificar la parte afectada)'
        end 
    end  

    
end
