class EpidemiologicalSurveillanceCasesController < ApplicationController

  before_action :set_epidemiological_surveillance_program
  before_action :set_epidemiological_surveillance_case, only: [:show, :edit, :update, :pdf]

  def index
    @epidemiological_surveillance_cases = @epidemiological_surveillance_program.epidemiological_surveillance_cases.includes(:entity, :user, :responsible, :surveillance_survey_response).order(opened_at: :desc)

  end

  def show
    @epidemiological_surveillance_case = @epidemiological_surveillance_program.epidemiological_surveillance_cases.includes(:entity, :user, :responsible, {surveillance_survey_response: [:surveillance_survey, {surveillance_answers: [:surveillance_question, {surveillance_answer_options: :surveillance_question_option}]}]}, :follow_ups, {epidemiological_surveillance_case_histories: :user}).find(params[:id])
  end

  def edit
  end

  def update
    ActiveRecord::Base.transaction do
      previous_status =  @epidemiological_surveillance_case.status
      @epidemiological_surveillance_case.update!(epidemiological_surveillance_case_params)

      new_status = @epidemiological_surveillance_case.status

      # ==========================================
      # HISTORIAL DE CAMBIO DE ESTADO
      # ==========================================
      if previous_status != new_status
        EpidemiologicalSurveillanceCaseHistory.create!(
          epidemiological_surveillance_case:
            @epidemiological_surveillance_case,
          user: Current.user,
          previous_status:
            EpidemiologicalSurveillanceCase.statuses[previous_status],
          new_status:
            EpidemiologicalSurveillanceCase.statuses[new_status],
          changed_at: Time.current,
          observations:
            @epidemiological_surveillance_case.observations
        )
      end

      # ==========================================
      #   FECHA DE CIERRE
      # ==========================================
      if @epidemiological_surveillance_case.closed?
        @epidemiological_surveillance_case.update!(closed_at: @epidemiological_surveillance_case.closed_at || Time.current)
      else
        @epidemiological_surveillance_case.update!(closed_at: nil)
      end
    end

    redirect_to(epidemiological_surveillance_program_epidemiological_surveillance_case_path(@epidemiological_surveillance_program, @epidemiological_surveillance_case), notice: "El caso SVE fue actualizado correctamente.")
    rescue ActiveRecord::RecordInvalid => e
    flash.now[:alert] = "No fue posible actualizar el caso SVE."
    render :edit, status: :unprocessable_entity

  end

  def pdf

    @epidemiological_surveillance_case = @epidemiological_surveillance_program.epidemiological_surveillance_cases.includes(:entity, :user, :responsible, {surveillance_survey_response: [:surveillance_survey, {surveillance_answers: [:surveillance_question, {surveillance_answer_options: :surveillance_question_option}]}]}, :follow_ups, {epidemiological_surveillance_case_histories: :user}).find(params[:id])

    html = render_to_string(template: "epidemiological_surveillance_cases/pdf", layout: "pdf")

    pdf =
      WickedPdf.new.pdf_from_string(
        html,
        page_size: "Letter",
        orientation: "Portrait",
        encoding: "UTF-8",
        margin: {
          top: 10,
          bottom: 10,
          left: 10,
          right: 10
        },
        enable_local_file_access: true
      )

    send_data(pdf, filename: "caso_sve_#{@epidemiological_surveillance_case.id}.pdf", type: "application/pdf", disposition: "inline")
    rescue ActiveRecord::RecordNotFound
    redirect_to(epidemiological_surveillance_program_epidemiological_surveillance_cases_path(@epidemiological_surveillance_program), alert: "El caso SVE no fue encontrado.")

  end

  private
  def set_epidemiological_surveillance_program
    @epidemiological_surveillance_program = EpidemiologicalSurveillanceProgram.find(params[:epidemiological_surveillance_program_id])

  end

  def set_epidemiological_surveillance_case
    @epidemiological_surveillance_case =  @epidemiological_surveillance_program.epidemiological_surveillance_cases.find(params[:id])

  end

  def epidemiological_surveillance_case_params
    params.require(:epidemiological_surveillance_case).permit(:user_id, :responsible_id, :source_type, :status, :opened_at, :closed_at, :observations, :symptom_onset, :symptom_start_date, :symptoms, :reported_diagnosis, :disability_days, :possible_occupational_exposure, :contact_with_symptomatic_people, :initial_measures, :return_to_work)
  end
  
end