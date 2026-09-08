class SurveillanceSurveysController < ApplicationController

  before_action :set_epidemiological_surveillance_program
  before_action :set_surveillance_survey,  only: %i[show edit update destroy]

  def index
    @surveillance_surveys = @epidemiological_surveillance_program.surveillance_surveys.includes(:surveillance_questions).order(created_at: :desc)
  end

  def show
    @surveillance_questions = @surveillance_survey.surveillance_questions.includes(:surveillance_question_options).order(:position)
  end

  def new
    @surveillance_survey = @epidemiological_surveillance_program.surveillance_surveys.new
    @surveillance_survey.version = 1
    @surveillance_survey.active = true
    @surveillance_survey.created_by_id = Current.user.id if Current.user
  end

  def edit
  end

  def create
    @surveillance_survey = @epidemiological_surveillance_program.surveillance_surveys.new(surveillance_survey_params)
    @surveillance_survey.created_by_id ||= Current.user.id if Current.user
    if @surveillance_survey.save
      redirect_to(epidemiological_surveillance_program_surveillance_survey_path(@epidemiological_surveillance_program, @surveillance_survey), notice: "La encuesta fue creada correctamente.")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @surveillance_survey.update(surveillance_survey_params)
      redirect_to(epidemiological_surveillance_program_surveillance_survey_path(@epidemiological_surveillance_program, @surveillance_survey), notice: "La encuesta fue actualizada correctamente.")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @surveillance_survey.destroy
      redirect_to(epidemiological_surveillance_program_surveillance_surveys_path(@epidemiological_surveillance_program), notice: "La encuesta fue eliminada correctamente.")
    else
      redirect_to(epidemiological_surveillance_program_surveillance_survey_path(@epidemiological_surveillance_program, @surveillance_survey), alert: "No fue posible eliminar la encuesta.")
    end
  end

  private

  def set_epidemiological_surveillance_program
    @epidemiological_surveillance_program = EpidemiologicalSurveillanceProgram.find(params[:epidemiological_surveillance_program_id])
  end

  def set_surveillance_survey
    @surveillance_survey =  @epidemiological_surveillance_program.surveillance_surveys.find(params[:id])

  end

  def surveillance_survey_params
    params.require(:surveillance_survey).permit(
      :name,
      :description,
      :version,
      :active
    )

  end

end
