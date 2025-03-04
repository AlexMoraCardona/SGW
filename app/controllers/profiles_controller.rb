class ProfilesController < ApplicationController
    def index
        if params[:entity_id].present? && Current.user 
            @entity = Entity.find(params[:entity_id])
            @survey_profiles = SurveyProfile.where("entity_id = ? and date_profile <= ? and date_vencimiento_profile >= ?", params[:entity_id].to_i, Date.today, Date.today)
        else    
            if  Current.user 
                @entities = Entity.all.order(id: :asc) if Current.user.level == 1
                @entities = Entity.find(Current.user.entity) if Current.user.level != 1 
            else
                redirect_to new_session_path, alert: t('common.not_logged_in')   
                session.delete(:user_id)   
            end           
        end
    end    

    def create
        @profile = Profile.new(profile_params)

        if @profile.save then
            redirect_to profiles_path, notice: t('.created') 
        else
            redirect_back fallback_location: root_path, alert: "Su encuesta no pudo ser enviada debido a que no autorizó el tratamiento de datos."
        end    
    end    

    def encuesta
        @int = 0
        if params[:survey_profile_id].present? && params[:id].present?
            @int = Profile.where("user_id = ? and survey_profile_id = ?", params[:id].to_i, params[:survey_profile_id].to_i).count
        end  
        @profile = Profile.new 
        @user_id =  params[:id].to_i  if params[:id].present?
        @survey_profile_id =  params[:survey_profile_id].to_i  if params[:survey_profile_id].present?
        user = User.find(@user_id) if @user_id.present?
        @entity = Entity.find(user.entity)

        if @int > 0
            redirect_to profiles_path, alert: 'Encuesta Sociodemográfica  ya fue realiza!', profile: :see_other    
        end    
    end

    def show
        if params[:entity_id].present? && Current.user 
            @entity = Entity.find(params[:entity_id])
            @survey_profiles = SurveyProfile.where("entity_id = ?", params[:entity_id].to_i).order(date_profile: :desc)  
        else    
            if  Current.user 
                @entities = Entity.all.order(id: :asc) if Current.user.level == 1
                @entities = Entity.find(Current.user.entity) if Current.user.level != 1 
            else
                redirect_to new_session_path, alert: t('common.not_logged_in')   
                session.delete(:user_id)   
            end           
        end

    end

    def informe
        @survey_profile = SurveyProfile.find(params[:id])
        @profiles = Profile.where("survey_profile_id = ?",@survey_profile.id) if @survey_profile.present?
        @template = Template.find(112)
        @administrative_political_division = AdministrativePoliticalDivision.find(@survey_profile.entity.entity_location_code) if @survey_profile.entity.entity_location_code.present?
        @cantidadsedes = Location.where("entity_id = ?", @survey_profile.entity_id).count 
        @responsablesst = User.find(@survey_profile.entity.responsible_sst) if @survey_profile.entity.responsible_sst.present?
        @economic_activity = EconomicActivityCode.find(@survey_profile.entity.economic_activity)
        @arl = OccupationalRiskManager.find(@survey_profile.entity.entity_arl)
        @claseriesgo = RiskLevel.find(@survey_profile.entity.risk_classification) if @survey_profile.entity.risk_classification.present?
        @user_elaboro = User.find(@survey_profile.user_elaboro) if @survey_profile.user_elaboro.present?
        @user_aprobo = User.find(@survey_profile.user_aprobo) if @survey_profile.user_aprobo.present?
        
        @datos_genero = Profile.vgenero(@survey_profile.id) if @survey_profile.present? 
        @cant_genero = Profile.cantidad_vector(@datos_genero) if @datos_genero.present?

        @datos_edad = Profile.vedad(@survey_profile.id) if @survey_profile.present? 
        @cant_edad = Profile.cantidad_vector(@datos_edad) if @datos_edad.present?

        @datos_estado_civil = Profile.vestadocivil(@survey_profile.id) if @survey_profile.present? 
        @cant_estado_civil = Profile.cantidad_vector(@datos_estado_civil) if @datos_estado_civil.present?
        
        @datos_hijos = Profile.vhijos(@survey_profile.id) if @survey_profile.present?
        @cant_hijos = Profile.cantidad_vector(@datos_hijos) if @datos_hijos.present?

        @datos_numero_hijos = Profile.vnumerohijos(@survey_profile.id) if @survey_profile.present?
        @cant_numero_hijos = Profile.cantidad_vector(@datos_numero_hijos) if @datos_numero_hijos.present?

        @datos_personas_cargo = Profile.vpersonasacargo(@survey_profile.id) if @survey_profile.present? 
        @cant_personas_cargo = Profile.cantidad_vector(@datos_personas_cargo) if @datos_personas_cargo.present?

        @datos_ciudad = Profile.vciudad(@survey_profile.id) if @survey_profile.present? 
        @cant_ciudad = Profile.cantidad_vector(@datos_ciudad) if @datos_ciudad.present?

        @datos_vivienda = Profile.vvivienda(@survey_profile.id) if @survey_profile.present? 
        @cant_vivienda = Profile.cantidad_vector(@datos_vivienda) if @datos_vivienda.present?

        @datos_estrato = Profile.vestrato(@survey_profile.id) if @survey_profile.present? 
        @cant_estrato = Profile.cantidad_vector(@datos_estrato) if @datos_estrato.present?

        @datos_nivel = Profile.vnivel(@survey_profile.id) if @survey_profile.present? 
        @cant_nivel = Profile.cantidad_vector(@datos_nivel) if @datos_nivel.present?

        @datos_salario = Profile.vsalario(@survey_profile.id) if @survey_profile.present? 
        @cant_salario = Profile.cantidad_vector(@datos_salario) if @datos_salario.present?

        @datos_contrato = Profile.vcontrato(@survey_profile.id) if @survey_profile.present? 
        @cant_contrato = Profile.cantidad_vector(@datos_contrato) if @datos_contrato.present?

        @datos_turno_trabajo = Profile.vturnotrabajo(@survey_profile.id) if @survey_profile.present? 
        @cant_turno_trabajo = Profile.cantidad_vector(@datos_turno_trabajo) if @datos_turno_trabajo.present?

        @datos_banco = Profile.vbanco(@survey_profile.id) if @survey_profile.present? 
        @cant_banco = Profile.cantidad_vector(@datos_banco) if @datos_banco.present?

        @datos_servicios = Profile.vservicios(@survey_profile.id) if @survey_profile.present? 
        @cant_servicios = Profile.cantidad_vector(@datos_servicios) if @datos_servicios.present?

        @datos_eps = Profile.veps(@survey_profile.id) if @survey_profile.present?
        @cant_eps = Profile.cantidad_vector(@datos_eps) if @datos_eps.present?

        @datos_pension = Profile.vpension(@survey_profile.id) if @survey_profile.present?
        @cant_pension = Profile.cantidad_vector(@datos_pension) if @datos_pension.present?

        @datos_arl = Profile.varl(@survey_profile.id) if @survey_profile.present? 
        @cant_arl = Profile.cantidad_vector(@datos_arl) if @datos_arl.present?

        @datos_discapacidad = Profile.vdiscapacidad(@survey_profile.id) if @survey_profile.present? 
        @cant_discapacidad = Profile.cantidad_vector(@datos_discapacidad) if @datos_discapacidad.present?

        @datos_tipo_discapacidad = Profile.vtipodiscapacidad(@survey_profile.id) if @survey_profile.present? 
        @cant_tipo_discapacidad = Profile.cantidad_vector(@datos_tipo_discapacidad) if @datos_tipo_discapacidad.present?

        @datos_tiempo = Profile.vtiempo(@survey_profile.id) if @survey_profile.present? 
        @cant_tiempo = Profile.cantidad_vector(@datos_tiempo) if @datos_tiempo.present?

        @datos_enfermedad = Profile.venfermedad(@survey_profile.id) if @survey_profile.present? 
        @cant_enfermedad = Profile.cantidad_vector(@datos_enfermedad) if @datos_enfermedad.present?

        @datos_fuma = Profile.vfuma(@survey_profile.id) if @survey_profile.present?
        @cant_fuma = Profile.cantidad_vector(@datos_fuma) if @datos_fuma.present?

        @datos_cual_fuma = Profile.vcualfuma(@survey_profile.id) if @survey_profile.present?
        @cant_cual_fuma = Profile.cantidad_vector(@datos_cual_fuma) if @datos_cual_fuma.present?

        @datos_bebida = Profile.vbebida(@survey_profile.id) if @survey_profile.present?
        @cant_bebida = Profile.cantidad_vector(@datos_bebida) if @datos_bebida.present?

        @datos_deporte = Profile.vdeporte(@survey_profile.id) if @survey_profile.present?
        @cant_deporte = Profile.cantidad_vector(@datos_deporte) if @datos_deporte.present?

        @datos_sangre = Profile.vsangre(@survey_profile.id) if @survey_profile.present? 
        @cant_sangre = Profile.cantidad_vector(@datos_sangre) if @datos_sangre.present?

        @datos_area = Profile.varea(@survey_profile.id) if @survey_profile.present?
        @cant_area = Profile.cantidad_vector(@datos_area) if @datos_area.present?

        @datos_cesantia = Profile.vcesantia(@survey_profile.id) if @survey_profile.present? 
        @cant_cesantia = Profile.cantidad_vector(@datos_cesantia) if @datos_cesantia.present?

        @datos_transporte = Profile.vtransporte(@survey_profile.id) if @survey_profile.present? 
        @cant_transporte = Profile.cantidad_vector(@datos_transporte) if @datos_transporte.present?

    end    

    def firma_elaboro
        @survey_profile = SurveyProfile.find_by(id: params[:id].to_i)
        if params[:format].to_i == 3
            if  @survey_profile.user_elaboro == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firma_elaboro_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Responsable en SST."
            end    
        end
    end    

    def firma_aprobo
        @survey_profile = SurveyProfile.find_by(id: params[:id].to_i)
        if params[:format].to_i == 1
            if  @survey_profile.user_aprobo == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firma_aprobo_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Representante Legal."
            end    
        end
    end    

    def fichatecnica
        @survey_profile = SurveyProfile.find_by(id: params[:id].to_i)
        @profiles = Profile.where(survey_profile_id: @survey_profile.id) if @survey_profile.present?
        @cantemp = User.where("entity = ?", @survey_profile.entity_id).count
        @empleados = User.where("entity = ?", @survey_profile.entity_id)
        @cantpendientes = 0
        @pendientes = []
        @ya = []
        @empleados.each do |empleado| 
            @encontro = 0
            @profiles.each do |profile|
                if profile.user_id.to_i == empleado.id.to_i then
                   @encontro = 1
                   @ya.push([empleado.id, empleado.nro_document, empleado.name])
                end
            end    
            if @encontro.to_i == 0 then
                @pendientes.push([empleado.id, empleado.nro_document, empleado.name])
                @cantpendientes += 1 
            end    
        end    
         
        @cantprofiles = @profiles.count 
    end    

    def detalles_profile
        @survey_profile = SurveyProfile.find_by(id: params[:id].to_i)
        @profiles = Profile.where(survey_profile_id: @survey_profile.id) if @survey_profile.present?
        @entity = Entity.find(@survey_profile.entity_id) if @survey_profile.present?
    end    

    def encuesta_profile
        @profile = Profile.find(params[:id])
    end    


    private

    def profile_params
        params.require(:profile).permit(:gender, :blood_type, :age, :weight, 
        :height, :civil_status, :education_level, :secretariat_belongs, 
        :dependency_belongs, :post_actual, :contract_type, :salary_range, 
        :emergency_contact, :phone_emergency_contact, :population_group, 
        :address, :neighborhood, :phone, :stratum_socioeconomic, :housing_type, 
        :basic_housing_services, :head_family, :has_children, :number_children, 
        :number_people_charge, :live_people_disability, :type_disability, 
        :use_time, :diagnosed_illness, :what_disease, :smoke, 
        :daily_average_smoke, :consume_alcoholic_beverages, :average_drinks, 
        :sports_practice, :average_sports, :conveyance, :accept_processing_data, 
        :user_id, :survey_profile_id, :health_promoter_id, :pension_fund_id, 
        :occupational_risk_manager_id, :administrative_political_division_id, 
        :Antiquity, :area_work, :cessation_fund_id, :email_name)
    end 





end  


 