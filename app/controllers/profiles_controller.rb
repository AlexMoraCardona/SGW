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
            @survey_profiles = SurveyProfile.where("entity_id = ?", params[:entity_id].to_i)  
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


 