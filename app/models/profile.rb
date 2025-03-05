class Profile < ApplicationRecord
    belongs_to :user
    belongs_to :survey_profile
    belongs_to :health_promoter
    belongs_to :pension_fund
    belongs_to :occupational_risk_manager
    belongs_to :administrative_political_division

    #validates :accept_processing_data, acceptance: { accept: ['FALSE', 'accepted'] }
    #validates :accept_processing_data, acceptance: false

    def graficosacpm
        @entity = Entity.find(params[:id])
        @matrix_corrective_action = MatrixCorrectiveAction.where('entity_id = ?', @entity.id) if @entity.present?
        @matrix_action_items = MatrixActionItem.where('matrix_corrective_action_id = ?', @matrix_corrective_action.ids) if @matrix_corrective_action.present?
        calculo_accion(@matrix_action_items)
    end

    def self.vgenero(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:gender).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end

    def self.labelgenero(dato)
        if dato == 0 ; 'Masculino'
        elsif  dato == 1 ; 'Femenino'
        elsif  dato == 2 ; 'No binario'
        elsif  dato == 3 ; 'Otro'
        end 
    end  
    
    def self.cantidad_vector(datos)
         cant = 0
         datos.each do |dato| 
            cant +=  dato[1].to_i 
         end

         return cant 
    end                

    
    def self.labelservicios(dato)
        if dato == 0 ; 'Energía, acueducto, alcantarillado'
        elsif  dato == 1 ; 'Energía, gas, acueducto, alcantarillado'
        elsif  dato == 2 ; 'Energía, gas, acueducto, alcantarillado, internet'
        end 
    end     

    def self.vservicios(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:basic_housing_services).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end

    def self.vedad(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:age).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end

    def self.labeledad(dato)
        if dato == 0 ; '18-27'
        elsif  dato == 1 ; '28-37'
        elsif  dato == 2 ; '38-47'
        elsif  dato == 3 ; '48-57'
        elsif  dato == 4 ; '58-67'
        elsif  dato == 5 ; 'Mayor de 67'
        end 
    end    

    def self.vestadocivil(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:civil_status).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end

    def self.labelestadocivil(dato)
        if dato == 0 ; 'Soltero (a)'
        elsif  dato == 1 ; 'Casado (a)'
        elsif  dato == 2 ; 'Unión libre'
        elsif  dato == 3 ; 'Viudo (a)'
        elsif  dato == 4 ; 'Divorciado/ separado (a)'
        end 
    end        

    def self.vpersonasacargo(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:number_people_charge).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end

    def self.labelpersonasacargo(dato)
        if dato == 0 ; 'Ninguna'
        elsif  dato == 1 ; '1-2'
        elsif  dato == 2 ; '3-4'
        elsif  dato == 3 ; '5-6'
        end 
    end 


    def self.vhijos(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:has_children).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end

    def self.labelhijos(dato)
        if dato == 0 ; 'Si'
        elsif  dato == 1 ; 'No'
        end 
    end 

    def self.labelnumerohijos(dato)
        if dato == 0 ; 'Ninguno'
        elsif  dato == 1 ; '1'
        elsif  dato == 2 ; '2'
        elsif  dato == 3 ; 'Más de 2'
        end 
    end     

    def self.vnumerohijos(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:number_children).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end


    def self.vciudad(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:administrative_political_division_id).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end
 
    def self.labelciudad(dato)
        ubica = AdministrativePoliticalDivision.find(dato) 
        dato = "#{ubica.town_center_name}"
    end 

    def self.vvivienda(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:housing_type).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end

    def self.labelvivienda(dato)
        if dato == 0 ; 'Propia'
        elsif  dato == 1 ; 'Arrendada'
        elsif  dato == 2 ; 'Familiar'
        end 
    end 
    def self.vestrato(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:stratum_socioeconomic).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end

    def self.labelestrato(dato)
        if dato == 0 ; '1'
        elsif  dato == 1 ; '2'
        elsif  dato == 2 ; '3'
        elsif  dato == 3 ; '4'
        elsif  dato == 4 ; '5'
        elsif  dato == 5 ; '6'
        end 
    end 
    def self.vnivel(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:education_level).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end

    def self.labelnivel(dato)
        if dato == 0 ; 'Primaria'
        elsif  dato == 1 ; 'Secundaria'
        elsif  dato == 2 ; 'Técnico'
        elsif  dato == 3 ; 'Tecnólogo'
        elsif  dato == 4 ; 'Profesional'
        elsif  dato == 5 ; 'Posgrado'
        end 
    end 
    def self.vsalario(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:salary_range).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end

    def self.labelsalario(dato)
        if dato == 0 ; 'De 1 a 2 SMLMV'
        elsif  dato == 1 ; 'De 3 a 4 SMLMV'
        elsif  dato == 2 ; 'Mas de 4 SMLMV'
        end 
    end 

    def self.vcontrato(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:contract_type).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end

    def self.labelcontrato(dato)
        if dato == 0 ; 'Contrato a Término Fijo'
        elsif  dato == 1 ; 'Contrato a término indefinido'
        elsif  dato == 2 ; 'Contrato de Obra o labor'
        elsif  dato == 3 ; 'Contrato civil por prestación de servicios'
        elsif  dato == 4 ; 'Contrato de aprendizaje'
        elsif  dato == 5 ; 'Contrato ocasional de trabajo'
        end 
    end  

    def self.labelturno(dato)
        if dato == 0 ; 'Diurno'
        elsif  dato == 1 ; 'Nocturno'
        elsif  dato == 2 ; 'Mixto'
        end 
    end      

    def self.vturnotrabajo(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:Antiquity).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end
    

    def self.veps(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:health_promoter_id).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end

    def self.labeleps(dato)
        dato = HealthPromoter.find(dato).name_entity
    end     

    def self.vpension(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:pension_fund_id).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end

    def self.labelpension(dato)
        dato = PensionFund.find(dato).fund
    end  
    
    def self.varl(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:occupational_risk_manager_id).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end

    def self.labelarl(dato)
        dato = OccupationalRiskManager.find(dato).name
    end    
    
    def self.vtiempo(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:use_time).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end

    def self.labeltiempo(dato)
        if dato == 0 ; 'Recreación y deporte'
        elsif  dato == 1 ; 'Labores domésticas'
        elsif  dato == 2 ; 'Estudio'
        elsif  dato == 3 ; 'Otro'
        end 
    end  
    
    def self.labelbanco(dato)
        if dato == 0 ; 'Banco de Bogotá'
        elsif  dato == 1 ; 'Banco Popular'
        elsif  dato == 2 ; 'Itaú Colombia'
        elsif  dato == 3 ; 'Bancolombia'
        elsif  dato == 4 ; 'Citibanck'
        elsif  dato == 5 ; 'GNB Sudameris'
        elsif  dato == 6 ; 'BBVA'
        elsif  dato == 7 ; 'Banco de Occidente'
        elsif  dato == 8 ; 'Banco Caja Social'
        elsif  dato == 9 ; 'Davivienda'
        elsif  dato == 10 ; 'Colpatria'
        elsif  dato == 11 ; 'Banco Agrario'
        elsif  dato == 12 ; 'Banco AV Villas'
        elsif  dato == 13 ; 'Ban100'
        elsif  dato == 14 ; 'Bancamia'
        elsif  dato == 15 ; 'Banco W'
        elsif  dato == 16 ; 'Coomeva'
        elsif  dato == 17 ; 'Banco Falabella'
        elsif  dato == 18 ; 'Banco Pichincha'
        elsif  dato == 19 ; 'Banco Santander'
        elsif  dato == 20 ; 'Banco Mundo Mujer'
        elsif  dato == 21 ; 'Lulubank'
        elsif  dato == 22 ; 'Nubank'
        elsif  dato == 23 ; 'Otro'
        end 
    end 

    def self.vbanco(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:head_family).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end

    def self.venfermedad(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:diagnosed_illness).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end

    def self.labelenfermedad(dato)
        if dato == 0 ; 'Si'
        elsif  dato == 1 ; 'No'
        end 
    end 

    def self.vfuma(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:smoke).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end

    def self.labelfuma(dato)
        if dato == 0 ; 'Si'
        elsif  dato == 1 ; 'No'
        end 
    end 

    def self.labelcualcigarrillo(dato)
        if dato == 0 ; 'N/A'
        elsif  dato == 1 ; 'Cigarrillo'
        elsif  dato == 2 ; 'Cigarrillo eléctronico'
        end 
    end  

    def self.vcualfuma(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:population_group).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end

    
    def self.labelpromediocigarrillo(dato)
        if dato == 0 ; 'N/A'
        elsif  dato == 1 ; 'Diario'
        elsif  dato == 2 ; 'Semanal'
        elsif  dato == 3 ; 'Quincenal'
        elsif  dato == 4 ; 'Mensual'
        elsif  dato == 5 ; 'Ocasional'
        end 
    end      

    def self.vbebida(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:consume_alcoholic_beverages).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end

    def self.labelbebida(dato)
        if dato == 0 ; 'Si'
        elsif  dato == 1 ; 'No'
        end 
    end 

    def self.labelpromediobebida(dato)
        if dato == 0 ; 'N/A'
        elsif  dato == 1 ; 'Diario'
        elsif  dato == 2 ; 'Semanal'
        elsif  dato == 3 ; 'Quincenal'
        elsif  dato == 4 ; 'Mensual'
        elsif  dato == 5 ; 'Ocasional'
        end 
    end      

    def self.vdeporte(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:sports_practice).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end

    def self.labeldeporte(dato)
        if dato == 0 ; 'Si'
        elsif  dato == 1 ; 'No'
        end 
    end 

    def self.labelpromediodeporte(dato)
        if dato == 0 ; 'N/A'
        elsif  dato == 1 ; 'Diario'
        elsif  dato == 2 ; 'Semanal'
        elsif  dato == 3 ; 'Quincenal'
        elsif  dato == 4 ; 'Mensual'
        elsif  dato == 5 ; 'Ocasional'
        end 
    end      


    def self.vsangre(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:blood_type).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end

    def self.labelsangre(dato)
        if dato == 0 ; 'A+'
        elsif  dato == 1 ; 'A-'
        elsif  dato == 2 ; 'B+'
        elsif  dato == 3 ; 'B-'
        elsif  dato == 4 ; 'AB+'
        elsif  dato == 5 ; 'AB-'
        elsif  dato == 6 ; 'O+'
        elsif  dato == 7 ; 'O-'
        end 
    end     
   
    def self.varea(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:area_work).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end

    def self.labelarea(dato)
        if dato == 0 ; 'Administrativa'
        elsif  dato == 1 ; 'Operativa'
        end 
    end 
    
    def self.labeldiscapacitadas(dato)
        if dato == 0 ; 'Si'
        elsif  dato == 1 ; 'No'
        end 
    end 

    def self.vdiscapacidad(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:live_people_disability).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end    

    def self.labeltipodiscapacitadas(dato)
        if dato == 0 ; 'Visual'
        elsif  dato == 1 ; 'Auditiva'
        elsif  dato == 2 ; 'Física'
        elsif  dato == 3 ; 'Mental'
        elsif  dato == 4 ; 'Múltiple'
        elsif  dato == 5 ; 'N/A'
        end 
    end  
    
    def self.vtipodiscapacidad(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:type_disability).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end       

    def self.vantiguedad(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:Antiquity).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end

    def self.labelantiguedad(dato)
        if dato == 0 ; '0 - 1'
        elsif  dato == 1 ; '2 - 3'
        elsif  dato == 2 ; '4 - 5'
        elsif  dato == 3 ; 'Mayor a 5 años'
        end 
    end 
   
    def self.vcesantia(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:cessation_fund_id).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end

    def self.labelcesantia(dato)
        dato = CessationFund.find(dato).name
    end    

    def self.labelmediotransporte(dato)
        if dato == 0 ; 'Moto'
        elsif  dato == 1 ; 'Carro'
        elsif  dato == 2 ; 'Bicicleta'
        elsif  dato == 3 ; 'Servicio público'
        elsif  dato == 4 ; 'A pie'
        elsif  dato == 5 ; 'Otro'
        end 
    end  
    
    def self.vtransporte(dato)
        profiles = Profile.where("survey_profile_id = ?", dato.to_i)
        @datos = []

        profiles.group_by(&:conveyance).each do |niv, det|
            @datos.push([niv, det.count])
        end
        return  @datos 
    end

    def self.labeltratamientodatos(dato)
        if dato == 0 ; 'Si'
        elsif  dato == 1 ; 'No'
        end 
    end     
    
end
