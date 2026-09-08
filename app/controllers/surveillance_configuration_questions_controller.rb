class SurveillanceConfigurationQuestionsController < ApplicationController
  before_action :set_surveillance_configuration
  before_action :set_surveillance_configuration_question, only: %i[edit update destroy]

  def new
    @surveillance_configuration_question =  @surveillance_configuration.surveillance_configuration_questions.new
    # Siguiente posición disponible
    @surveillance_configuration_question.position = (@surveillance_configuration.surveillance_configuration_questions.maximum(:position) || 0) + 1
  end

  def create
    @surveillance_configuration_question = @surveillance_configuration.surveillance_configuration_questions.new(surveillance_configuration_question_params)

    if @surveillance_configuration_question.save
      redirect_to @surveillance_configuration, notice: "La pregunta fue creada correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @surveillance_configuration_question.update(surveillance_configuration_question_params)
      redirect_to @surveillance_configuration, notice: "La pregunta fue actualizada correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @surveillance_configuration_question.destroy
      redirect_to @surveillance_configuration, notice: "La pregunta fue eliminada correctamente."
    else
      redirect_to @surveillance_configuration, alert: "No fue posible eliminar la pregunta."
    end
  end

  private

  def set_surveillance_configuration
    @surveillance_configuration = SurveillanceConfiguration.find(params[:surveillance_configuration_id])
  end

  def set_surveillance_configuration_question
    @surveillance_configuration_question = @surveillance_configuration.surveillance_configuration_questions.find(params[:id])
  end

  def surveillance_configuration_question_params
    params
      .require(:surveillance_configuration_question)
      .permit(
        :question,
        :question_type,
        :position,
        :required,
        :help_text,
        :status
      )
  end
end
