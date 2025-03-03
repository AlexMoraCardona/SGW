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

    private

    def survey_profile_params 
        params.require(:survey_profile).permit(:date_profile, :date_vencimiento_profile, :entity_id, :user_elaboro, 
        :user_reviso, :user_aprobo, :date_firm_elaboro, :date_firm_reviso, :date_firm_aprobo, 
        :firm_elaboro, :firm_aprobo, :firm_reviso)
    end 

end  
