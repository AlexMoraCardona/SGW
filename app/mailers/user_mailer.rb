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
end
