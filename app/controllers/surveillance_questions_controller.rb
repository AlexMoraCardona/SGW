class SurveillanceQuestionsController < ApplicationController

  before_action :set_epidemiological_surveillance_program
  before_action :set_surveillance_survey
  before_action :set_surveillance_question, only: %i[show edit update destroy]

  def index
    @surveillance_questions = @surveillance_survey.surveillance_questions.includes(:surveillance_question_options).order(:position)
  end

  def show
    @surveillance_question_options = @surveillance_question.surveillance_question_options.order(:position)
  end

  def new
    @surveillance_question = @surveillance_survey.surveillance_questions.new
    @surveillance_question.position = (@surveillance_survey.surveillance_questions.maximum(:position) || 0) + 1
    @surveillance_question.required = true
    @surveillance_question.active = true
    @surveillance_question.question_type = :open_text
  end

  def edit
  end

  def create
    @surveillance_question = @surveillance_survey.surveillance_questions.new(surveillance_question_params)

    if @surveillance_question.save
      redirect_to(epidemiological_surveillance_program_surveillance_survey_surveillance_questions_path(@epidemiological_surveillance_program, @surveillance_survey), notice: "La pregunta fue creada correctamente.")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @surveillance_question.update(surveillance_question_params)
      redirect_to(epidemiological_surveillance_program_surveillance_survey_surveillance_questions_path(@epidemiological_surveillance_program, @surveillance_survey), notice: "La pregunta fue actualizada correctamente.")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @surveillance_question.destroy
      redirect_to(epidemiological_surveillance_program_surveillance_survey_surveillance_questions_path(@epidemiological_surveillance_program, @surveillance_survey), notice: "La pregunta fue eliminada correctamente.")
    else
      redirect_to(epidemiological_surveillance_program_surveillance_survey_surveillance_questions_path(@epidemiological_surveillance_program, @surveillance_survey), alert: "No fue posible eliminar la pregunta.")
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
      @surveillance_question = @surveillance_survey.surveillance_questions.find(params[:id])
    end

    def surveillance_question_params
        params.require(:surveillance_question).permit(
        :question,
        :question_type,
        :position,
        :required,
        :active
      )
    end
end