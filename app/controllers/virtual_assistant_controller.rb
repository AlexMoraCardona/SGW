class VirtualAssistantController < ApplicationController

  before_action :verify_virtual_assistant_user

  def index
  end

  def message
    message = params[:message].to_s.strip.downcase

    response = process_message(message)

    render json: response
  end

  private

  def verify_virtual_assistant_user
    unless Current.user.present?
      render json: {
        success: false,
        type: "message",
        message: "Debes iniciar sesión para utilizar el Asistente Virtual de CONESST."
      }, status: :unauthorized
    end
  end

  def process_message(message)

    if message.match?(/crear.*usuario|nuevo.*usuario|registrar.*usuario/)
      entity = Entity.find_by(id: Current.user.entity)
      if Current.user.level == 2 && entity && entity.external_consultant.to_i == Current.user.id
        {
          success: true,
          type: "navigation",
          message: "Claro. Te llevaré al formulario para crear un usuario.",
          url: new_user_path
        }
      else
        {
          success: false,
          type: "message",
          message: "No tienes autorización para crear usuarios para esta empresa."
        }
      end
    elsif message.match?(/matriz.*riesgo|riesgo.*matriz|crear.*matriz/)
      {
        success: true,
        type: "navigation",
        message: "Claro. Te llevaré al formulario para crear una matriz de riesgos.",
        url: new_analysis_risk_path
      }

    else
      {
        success: false,
        type: "message",
        message: "Todavía no reconozco esa solicitud. Puedes decirme, por ejemplo: 'crear usuario' o 'crear matriz de riesgos'."
      }
    end
  end
end
