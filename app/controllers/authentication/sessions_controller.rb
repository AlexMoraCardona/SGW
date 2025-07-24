class Authentication::SessionsController < ApplicationController
    skip_before_action :protect_pages
    
    def new

    end

    def create
        @user = User.find_by("(email = :login OR username = :login) AND state = 1 ", { login: params[:login]})

        if @user&.authenticate(params[:password]) 
            
            session[:user_id] = @user.id
            if @user.authorization_police == 0
                redirect_to autorizacion_politica_path(@user.id)
            elsif @user.date_change_password.present? && ((DateTime.now  - @user.date_change_password).round > 60)
                redirect_to cambiar_clave_path(@user.id)
            elsif @user.date_change_password.blank?
                redirect_to cambiar_clave_path(@user.id)                
            else    
                redirect_to home_path, notice: t('.created')
            end                
        else
            redirect_to new_session_path, alert: t('.failed')
            session.delete(:user_id)
        end     
    end  
    
    def destroy
        if Current.user.id.present?
            User.actualizalogin(Current.user.id)
        end    
        session.delete(:user_id)
        redirect_to new_session_path, notice: t('.destroyed')
    end 
    
    def cambioclave

    end   

    def generarclave
        if params[:usu].present? &&  params[:usu].present? then
            @user = User.find_by("username = ? AND nro_document = ? ", params[:usu], params[:doc] )
            if @user.present? then
                num_aleat = ''
                6.times do
                    numero = %w{ 0 1 2 3 4 5 6 7 8 9 A B C D E F G H I J K L M N O P Q R S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z + - * /}
                    num = rand(numero.length)
                    num_aleat << numero[num].to_s
                end
                @user.password = num_aleat
                if @user.save then 
                    UserMailer.with(user: @user, clave: num_aleat).cambiocla.deliver_later 
                    redirect_to new_session_path, notice: t('.correctocambio') 
                else
                    redirect_to new_session_path, alert: t('.errorcambio')
                end
            else
                redirect_to new_session_path, alert: t('.errorcambio') 
            end    
        else
            redirect_to new_session_path, alert: t('.errorcambio')  
        end  

    end   
    
end     
