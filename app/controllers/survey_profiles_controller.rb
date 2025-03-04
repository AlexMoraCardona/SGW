class SurveyProfilesController < ApplicationController
    def index
        if params[:entity_id].present?
            @entity = Entity.find(params[:entity_id])
            @survey_profiles = SurveyProfile.where("entity_id = ?", params[:entity_id]).order(date_profile: :desc)
        else    
            if  Current.user && (Current.user.level == 1 || Current.user.level == 2)
                @entities = Entity.all
                @survey_profiles = SurveyProfile.all.order(:date_profile)
            else
                redirect_to new_session_path, alert: t('common.not_logged_in')      
                session.delete(:user_id)
            end           
        end 
    end    

    def new
      @survey_profile = SurveyProfile.new  
    end    

    def create
        @survey_profile = SurveyProfile.new(survey_profile_params)

        if @survey_profile.save then
            redirect_to survey_profiles_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @survey_profile = SurveyProfile.find(params[:id])
        @entity = Entity.find(@survey_profile.entity_id) if @survey_profile.present?
    end
    
    def update
        @survey_profile = SurveyProfile.find(params[:id])
        if @survey_profile.update(survey_profile_params)
            actualizar_fecha(@survey_profile_id)
            redirect_to survey_profiles_path, notice: 'Encuesta Sociodemográfica actualizada correctamente'
        else
            render :edit, survey_profiles: :unprocessable_entity
        end         
    end    
    
    def actualizar_fecha(id)
        @survey_profile = SurveyProfile.find(id)
        @survey_profile.date_firm_aprobo = nil if @survey_profile.firm_aprobo.to_i == 0
        @survey_profile.date_firm_elaboro = nil if @survey_profile.firm_elaboro.to_i == 0
        @survey_profile.save
    end  

    def destroy
        @survey_profile = SurveyProfile.find(params[:id])
        @survey_profile.destroy
        redirect_to survey_profiles_path, notice: 'Encuesta Sociodemográfica borrada correctamente', survey_profile: :see_other
    end  
    
    def informe_estudio_socio
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

        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'informe_estudio_socio',
                margin: {top: 10, bottom: 10, left: 10, right: 10 },
                disable_javascript: true,
                page_size: 'letter',
                footer: {
                    right: 'Página: [page] de [topage]'
                   }                
                       } 
        end
    end   


    private

    def survey_profile_params 
        params.require(:survey_profile).permit(:date_profile, :date_vencimiento_profile, :entity_id, :user_elaboro, 
        :user_reviso, :user_aprobo, :date_firm_elaboro, :date_firm_reviso, :date_firm_aprobo, 
        :firm_elaboro, :firm_aprobo, :firm_reviso)
    end 

end  
