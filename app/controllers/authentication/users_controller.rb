class Authentication::UsersController < ApplicationController
    skip_before_action :protect_pages 

    def index
        if  Current.user && Current.user.level > 0 && Current.user.level < 3
           #@users = User.all.decorate
           @q = User.ransack(params[:q])
           @pagy, @users = pagy(@q.result(id: :desc), items: 3)

        else
            redirect_to new_session_path, alert: t('common.not_logged_in')      
            session.delete(:user_id)

        end    
    end    
 
    
    def new
        @user = User.new 
    end

    def create
        @user = User.new(user_params)
        if @user.save 
            session[:user_id] = @user.id  
            session.delete(:user_id)
            redirect_to levels_path, notice: 'Usuario creado correctamente'
        else
            render :new, status: :unprocessable_entity
        end     
    end   
    
    def edit
        @user = User.find(params[:id])
        if @user.level == 1 ||  @user.level == 2
            @company_positions = CompanyPosition.all if @user.entity.present?
            @company_areas = CompanyArea.all if @user.entity.present?
        else    
            @company_positions = CompanyPosition.where("entity_id = ?",@user.entity.to_i) if @user.entity.present?
            @company_areas = CompanyArea.where("entity_id = ?",@user.entity.to_i) if @user.entity.present?
        end    
    end
    
    def update
        @user = User.find(params[:id])
        if @user.update(user_params)
            redirect_to home_path, notice: 'Actualizado correctamente'
        else
            render :edit, status: :unprocessable_entity
        end         
    end    

    def destroy
        @user = User.find(params[:id])
        @user.destroy
        redirect_to users_path, notice: 'Usuario borrado correctamente', user: :see_other
    end    
    
    def cambio_empresa
        @user = User.find(params[:id])

    end  

    def cambiar_clave
        if  Current.user.present?
            @user = User.find(Current.user.id)
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')      
            session.delete(:user_id)            
        end    
    end  


    def politicas

    end    

    

    private
    def user_params
        params.require(:user).permit(:nro_document, :name, :username, :email, :password, :state, :level, :entity, :activity, :avatar, :firm, :document_id, 
        :legal_representative, :copasst, :ccl, :collaborator, :president_copasst, :secretary_copasst, :vigia_sgsst, 
        :cargo_rol, :brigade, :cel, :phone, :clasification_post, :sex, :date_entry_company, :date_retirement_company, :date_nacimiento, :area_employee, :authorization_police, :authorization_date, :license, :de_license)
    end    
end    