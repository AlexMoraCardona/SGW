class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.ingreso.subject
  #
  def ingreso
    @user = params[:user]
    if @user.present?
      @username = @user.username
      mail to: @user.email
    end  
    
  end

  def cambiocla
    @user = params[:user]
    if @user.present?
      @username = @user.name 
      @clave = params[:clave]
      mail to: @user.email
    end  
  end

  def citacion
    @user = params[:user]
    @reunion = params[:reunion]
    @lugar = params[:lugar] 
    @observaciones = params[:observaciones]
    @hora = params[:hora] 
    @dia =params[:dia] 
    @nombredia = params[:nombredia] 
    @mes = params[:mes] 
    @nombremes = params[:nombremes] 
    @año = params[:año]
    @convocanombre = params[:convocanombre]
    @convocacargo = params[:convocacargo]


    if @user.present?
      @username = @user.name 
      mail(to: @user.email, subject: "Citación")
    end 

  end

  def compromiso
    @user = params[:user]
    @fechaacor = params[:fechaacor]
    @compromiso = params[:compromiso] 
    @esperado = params[:esperado]
    @nombreelaboro = params[:nombreelaboro]
    @cargo = params[:cargo]
    
    if @user.present?
      @username = @user.name 
      mail(to: @user.email, subject: "Compromiso acta de reunión")
    end 

  end
  
end
