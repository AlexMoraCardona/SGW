class Authentication::SessionsController < ApplicationController
    skip_before_action :protect_pages
    require "net/http"
    require "json"
    require "uri"
    require "securerandom"

    def new

    end

    def create
        @user = User.find_by("email = :login OR username = :login", { login: params[:login] })

        # Verificación Cloudflare Turnstile
        turnstile_token = params["cf-turnstile-response"]

        unless CloudflareTurnstileVerifier.verify(turnstile_token, request.remote_ip, type: :login)

            LoginAudit.create!(user: @user, success: false, ip_address: request.remote_ip, reason: "Verificación de seguridad fallida")

            redirect_to new_session_path, alert: "No fue posible validar la verificación de seguridad. Intenta nuevamente."
            return
        end

        # Usuario bloqueado
        if @user && @user.state.to_i == 0
            @user.login_audits.create!(success: false, ip_address: request.remote_ip, reason: "Usuario bloqueado")
            redirect_to new_session_path, alert: "Tu usuario ha sido bloqueado por múltiples intentos fallidos. Comunícate con tu Asesor de CONESST para solicitar el desbloqueo."
            return
        end

        # Usuario y contraseña correctos
        if @user&.authenticate(params[:password])
            login_attempt = @user.login_attempt
            if login_attempt
                login_attempt.reset_attempts
            end

            @user.login_audits.create!(success: true, ip_address: request.remote_ip, reason: "Login correcto")

            session[:user_id] = @user.id

            login_session = @user.login_sessions.create!(started_at: Time.current, ip_address: request.remote_ip)

            session[:login_session_id] = login_session.id

            if @user.authorization_police == 0
                redirect_to autorizacion_politica_path(@user.id)
            elsif @user.date_change_password.present? && ((DateTime.now - @user.date_change_password).round > 60)
                redirect_to cambiar_clave_path(@user.id)
            elsif @user.date_change_password.blank?
                redirect_to cambiar_clave_path(@user.id)
            else
                redirect_to home_path, notice: t('.created')
            end
        else
            if @user
                @user.login_audits.create!(success: false, ip_address: request.remote_ip, reason: "Contraseña incorrecta")
                login_attempt = @user.login_attempt || @user.create_login_attempt
                blocked = login_attempt.register_failed_attempt
                if blocked
                    redirect_to new_session_path, alert: "Tu usuario ha sido bloqueado por múltiples intentos fallidos. Comunícate con tu Asesor de CONESST para solicitar el desbloqueo."
                else
                    redirect_to new_session_path, alert: t('.failed')
                end
            else
                LoginAudit.create!(user: nil, success: false, ip_address: request.remote_ip, reason: "Usuario no encontrado")
                redirect_to new_session_path, alert: t('.failed')
            end
            session.delete(:user_id)
        end
    end

    def destroy
        if session[:login_session_id].present?
            login_session = LoginSession.find_by(id: session[:login_session_id])
            login_session&.update(ended_at: Time.current)
        end

        if Current.user.present? && Current.user.id.present?
            User.actualizalogin(Current.user.id)
        end

        session.delete(:login_session_id)
        session.delete(:user_id)

        redirect_to new_session_path, notice: t('.destroyed')
    end    
    
    def cambioclave

    end   

def generarclave

    # ==========================================================
    # 1. Validar usuario y documento
    # ==========================================================

    unless params[:usu].present? && params[:doc].present?
        redirect_to new_session_path, alert: t('.errorcambio')
        return
    end


    # ==========================================================
    # 2. Obtener token generado por Cloudflare Turnstile
    # ==========================================================

    turnstile_token = params["cf-turnstile-response"].to_s

    if turnstile_token.blank? || turnstile_token.length > 2048
        Rails.logger.warn(
            "Solicitud cambio de clave rechazada: " \
            "token Turnstile ausente o inválido. " \
            "IP: #{request.remote_ip}"
        )

        redirect_to new_session_path, alert: t('.errorcambio')
        return
    end


    # ==========================================================
    # 3. Validar token con Cloudflare
    # ==========================================================

    begin

        uri = URI.parse(
            "https://challenges.cloudflare.com/turnstile/v0/siteverify"
        )

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        # Evita que una falla de conexión deje bloqueado el proceso
        http.open_timeout = 5
        http.read_timeout = 10

        request_cloudflare = Net::HTTP::Post.new(uri.request_uri)

        request_cloudflare[
            "Content-Type"
        ] = "application/x-www-form-urlencoded"

        request_cloudflare.set_form_data(
            secret: Rails.application.credentials.dig(
                :cloudflare_turnstile,
                :recovery_secret_key
            ),
            response: turnstile_token,
            remoteip: request.remote_ip
        )

        response_cloudflare = http.request(request_cloudflare)

        turnstile_result = JSON.parse(response_cloudflare.body)


    rescue StandardError => e

        Rails.logger.error(
            "Error validando Cloudflare Turnstile: " \
            "#{e.class} - #{e.message}"
        )

        redirect_to new_session_path, alert: t('.errorcambio')
        return
    end


    # ==========================================================
    # 4. Comprobar respuesta de Cloudflare
    # ==========================================================

    unless response_cloudflare.is_a?(Net::HTTPSuccess) &&
           turnstile_result["success"] == true

        Rails.logger.warn(
            "Turnstile rechazó solicitud de cambio de clave. " \
            "IP: #{request.remote_ip} - " \
            "Errores: #{turnstile_result['error-codes']}"
        )

        redirect_to new_session_path, alert: t('.errorcambio')
        return
    end


    # ==========================================================
    # 5. Buscar usuario
    # ==========================================================

    @user = User.find_by(
        "username = ? AND nro_document = ?",
        params[:usu],
        params[:doc]
    )


    unless @user.present?

        redirect_to new_session_path, alert: t('.errorcambio')
        return
    end


    # ==========================================================
    # 6. Generar nueva clave temporal
    # ==========================================================

    num_aleat = SecureRandom.alphanumeric(12)


    # ==========================================================
    # 7. Guardar nueva clave
    # ==========================================================

    @user.password = num_aleat


    if @user.save

        # ======================================================
        # 8. Enviar nueva clave por correo
        # ======================================================

        UserMailer.with(
            user: @user,
            clave: num_aleat
        ).cambiocla.deliver_later


        redirect_to new_session_path,
                    notice: t('.correctocambio')

    else

        redirect_to new_session_path,
                    alert: t('.errorcambio')
    end

end

    


end     
