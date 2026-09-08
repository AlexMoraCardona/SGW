class SurveillanceQuestionOptionsController < ApplicationController

  before_action :set_epidemiological_surveillance_program
  before_action :set_surveillance_survey
  before_action :set_surveillance_question

  before_action :set_surveillance_question_option, only: %i[show edit update destroy]

  def index
    @surveillance_question_options = @surveillance_question.surveillance_question_options.order(:position)
  end

  def show
  end

  def new
    @surveillance_question_option =  @surveillance_question.surveillance_question_options.new
    @surveillance_question_option.position =  (@surveillance_question.surveillance_question_options.maximum(:position) || 0) + 1
    @surveillance_question_option.active = true
  end

  def edit
  end

  def create

    @surveillance_question_option = @surveillance_question.surveillance_question_options.new(surveillance_question_option_params)

    # Generar automáticamente el valor interno
    @surveillance_question_option.option_value =  @surveillance_question_option.option_text.to_s.parameterize(separator: "_")

    # Generar automáticamente la posición
    @surveillance_question_option.position = (@surveillance_question.surveillance_question_options.maximum(:position) || 0) + 1
    if @surveillance_question_option.save
      redirect_to(epidemiological_surveillance_program_surveillance_survey_surveillance_question_surveillance_question_options_path(@epidemiological_surveillance_program, @surveillance_survey, @surveillance_question), notice: "La opción fue creada correctamente.")
    else
      render :new, status: :unprocessable_entity
    end

  end

  def update
    if @surveillance_question_option.update(surveillance_question_option_params)
      redirect_to(epidemiological_surveillance_program_surveillance_survey_surveillance_question_surveillance_question_options_path(@epidemiological_surveillance_program, @surveillance_survey, @surveillance_question), notice: "La opción fue actualizada correctamente.")
    else
      render :edit, status: :unprocessable_entity
    end

  end

  def destroy
    if @surveillance_question_option.destroy
      redirect_to(epidemiological_surveillance_program_surveillance_survey_surveillance_question_surveillance_question_options_path(@epidemiological_surveillance_program, @surveillance_survey, @surveillance_question), notice: "La opción fue eliminada correctamente.")
    else
      redirect_to(epidemiological_surveillance_program_surveillance_survey_surveillance_question_surveillance_question_options_path(@epidemiological_surveillance_program, @surveillance_survey, @surveillance_question), alert: "No fue posible eliminar la opción.")
    end

  end

  private

  def set_epidemiological_surveillance_program
    @epidemiological_surveillance_program = EpidemiologicalSurveillanceProgram.find(params[:epidemiological_surveillance_program_id])

  end

  def set_surveillance_survey
    @surveillance_survey = @epidemiological_surveillance_program.surveillance_surveys.find(params[:surveillance_survey_id])

  end

  def set_surveillance_question
    @surveillance_question = @surveillance_survey.surveillance_questions.find(params[:surveillance_question_id])

  end

  def set_surveillance_question_option
    @surveillance_question_option = @surveillance_question.surveillance_question_options.find(params[:id])

  end

  def surveillance_question_option_params
    params.require(:surveillance_question_option).permit(
      :option_text,
      :option_value,
      :position,
      :active
    )
  end

end