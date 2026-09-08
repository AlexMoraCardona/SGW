class SurveillanceConfigurationQuestionOptionsController < ApplicationController
  before_action :set_surveillance_configuration
  before_action :set_surveillance_configuration_question
  before_action :set_surveillance_configuration_question_option, only: %i[edit update destroy]

  def new
    @surveillance_configuration_question_option = @surveillance_configuration_question.surveillance_configuration_question_options.new
    @surveillance_configuration_question_option.position = (@surveillance_configuration_question.surveillance_configuration_question_options.maximum(:position) || 0) + 1
  end

  def create
    @surveillance_configuration_question_option = @surveillance_configuration_question.surveillance_configuration_question_options.new(surveillance_configuration_question_option_params)

    if @surveillance_configuration_question_option.save
      redirect_to surveillance_configuration_path(@surveillance_configuration), notice: "La opción fue creada correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @surveillance_configuration_question_option.update(surveillance_configuration_question_option_params)
      redirect_to surveillance_configuration_path(@surveillance_configuration), notice: "La opción fue actualizada correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @surveillance_configuration_question_option.destroy
      redirect_to surveillance_configuration_path(@surveillance_configuration), notice: "La opción fue eliminada correctamente."
    else
      redirect_to surveillance_configuration_path(@surveillance_configuration), alert: "No fue posible eliminar la opción."
    end
  end

  private

  def set_surveillance_configuration
    @surveillance_configuration = SurveillanceConfiguration.find(params[:surveillance_configuration_id])
  end

  def set_surveillance_configuration_question
    @surveillance_configuration_question = @surveillance_configuration.surveillance_configuration_questions.find(params[:surveillance_configuration_question_id])
  end

  def set_surveillance_configuration_question_option
    @surveillance_configuration_question_option =  @surveillance_configuration_question.surveillance_configuration_question_options.find(params[:id])
  end

  def surveillance_configuration_question_option_params
    params.require(
      :surveillance_configuration_question_option
    ).permit(
      :option,
      :position,
      :status
    )
  end
end
