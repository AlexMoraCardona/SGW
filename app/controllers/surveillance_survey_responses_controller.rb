class SurveillanceSurveyResponsesController < ApplicationController

  before_action :set_epidemiological_surveillance_program
  before_action :set_surveillance_survey


  def index
    @surveillance_survey_responses = @surveillance_survey.surveillance_survey_responses.includes(:user).order(response_date: :desc)
  end

  def show
    @surveillance_survey_response =  @surveillance_survey.surveillance_survey_responses.includes(:user, surveillance_answers: [:surveillance_question, { surveillance_answer_options: :surveillance_question_option }]).find(params[:id])
  end

  def review
    @surveillance_survey_response = @surveillance_survey.surveillance_survey_responses.find(params[:id])
    decision = params[:decision]
    observations = params[:observations]

    unless %w[select not_candidate].include?(decision)
      redirect_to(epidemiological_surveillance_program_surveillance_survey_surveillance_survey_response_path(@epidemiological_surveillance_program, @surveillance_survey, @surveillance_survey_response), alert: "La decisión de revisión no es válida.")
      return
    end

    if @surveillance_survey_response.review_status == "reviewed"
      redirect_to(epidemiological_surveillance_program_surveillance_survey_surveillance_survey_response_path(@epidemiological_surveillance_program, @surveillance_survey, @surveillance_survey_response), alert: "Esta respuesta ya fue revisada.")
      return
    end

    ActiveRecord::Base.transaction do
      if decision == "select"
        @surveillance_survey_response.update!(
          review_status: :reviewed,
          reviewed_by_id: Current.user.id,
          reviewed_at: Time.current,
          selected_for_sve: true,
          selected_at: Time.current,
          status: :in_evaluation,
          observations: observations
        )

        # Evitar crear un caso duplicado
        unless @surveillance_survey_response
                 .epidemiological_surveillance_case
                 .present?

          sve_case = EpidemiologicalSurveillanceCase.create!(epidemiological_surveillance_program_id: @epidemiological_surveillance_program.id, entity_id: @surveillance_survey_response.entity_id, user_id: @surveillance_survey_response.user_id, source_type: :survey, surveillance_survey_response_id: @surveillance_survey_response.id, opened_at: Time.current, status: :in_evaluation, responsible_id: Current.user.id, observations: observations.presence || "Caso generado a partir de la encuesta de identificación.")

          # ==========================================
          # HISTORIAL INICIAL DEL CASO
          # ==========================================
          EpidemiologicalSurveillanceCaseHistory.create!(epidemiological_surveillance_case: sve_case, user: Current.user, previous_status: nil, new_status:  EpidemiologicalSurveillanceCase.statuses[:in_evaluation], changed_at: Time.current, observations: "Caso creado a partir de la selección de la encuesta para SVE.")
        end

        notice =
          "La respuesta fue seleccionada para el SVE y se creó el caso epidemiológico."
      else
          @surveillance_survey_response.update!(review_status: :reviewed, reviewed_by_id: Current.user.id, reviewed_at: Time.current, selected_for_sve: false, selected_at: nil, status: :not_candidate, observations: observations)
           notice = "La respuesta fue revisada y marcada como no candidata para el SVE."
      end
    end

    redirect_to(epidemiological_surveillance_program_surveillance_survey_surveillance_survey_response_path(@epidemiological_surveillance_program, @surveillance_survey, @surveillance_survey_response), notice: notice)
    rescue ActiveRecord::RecordInvalid => e
    redirect_to(epidemiological_surveillance_program_surveillance_survey_surveillance_survey_response_path(@epidemiological_surveillance_program, @surveillance_survey, @surveillance_survey_response), alert: "No fue posible realizar la revisión: #{e.message}")

  end

  def new
    @surveillance_survey_response =  @surveillance_survey.surveillance_survey_responses.new
    @users = @epidemiological_surveillance_program.surveillance_workers.where(status: :active).includes(:user).map(&:user).sort_by { |user| user.name.to_s.downcase }

    # ==========================================================
    # USUARIO SELECCIONADO DESDE NOTIFICACIÓN
    # ==========================================================
    if params[:from_notification] == "true" && params[:user_id].present?
        @selected_user = @users.find { |user| user.id == params[:user_id].to_i }
        if @selected_user.present?
            @surveillance_survey_response.user_id = @selected_user.id
        end
    end

    @questions = @surveillance_survey.surveillance_questions.where(active: true).includes(:surveillance_question_options).order(:position)
  end

  def create
    worker = @epidemiological_surveillance_program.surveillance_workers.where(status: :active).find_by(user_id: params[:surveillance_survey_response][:user_id])
    unless worker
      redirect_to(new_epidemiological_surveillance_program_surveillance_survey_surveillance_survey_response_path(@epidemiological_surveillance_program, @surveillance_survey), alert: "El trabajador seleccionado no está vinculado como trabajador activo de este programa SVE.")
      return
    end

    ActiveRecord::Base.transaction do
      @surveillance_survey_response = @surveillance_survey.surveillance_survey_responses.new(
      user_id: worker.user_id,
      entity_id: @epidemiological_surveillance_program.entity_id,
      response_date: Time.current,
      review_status: :review_pending,
      selected_for_sve: false,
      status: :pending
      )

      @surveillance_survey_response.save!
      answers = params[:answers] || {}

      @surveillance_survey.surveillance_questions.where(active: true).order(:position).each do |question|
        answer_params = answers[question.id.to_s] || {}
        answer = @surveillance_survey_response.surveillance_answers.new(surveillance_question: question)

        case question.question_type
          when "open_text"
            answer.answer_text = answer_params[:answer_text]
          when "boolean"
            value = answer_params[:answer_boolean]
            answer.answer_boolean =  if value == "true"
              true
            elsif value == "false"
              false
            else
              nil
            end
          when "single_choice", "multiple_choice"
            option_ids = Array(answer_params[:option_ids]).reject(&:blank?).map(&:to_i)
            valid_option_ids = question.surveillance_question_options.where(active: true).where(id: option_ids).pluck(:id)
            if question.question_type == "single_choice" &&
              valid_option_ids.length > 1
              raise ActiveRecord::Rollback
            end
            answer.save!
            valid_option_ids.each do |option_id|
              answer.surveillance_answer_options.create!(surveillance_question_option_id: option_id)
            end
          next
        end
        answer.save!
      end
    end

    # ==========================================================
    # REDIRECCIÓN SEGÚN EL ORIGEN DE LA ENCUESTA
    # ==========================================================

    if params[:from_notification] == "true"
      redirect_to(root_path, notice: "La encuesta fue registrada correctamente y quedó pendiente de revisión.")
    else
      redirect_to(epidemiological_surveillance_program_surveillance_survey_path(@epidemiological_surveillance_program, @surveillance_survey), notice: "La encuesta fue registrada correctamente y quedó pendiente de revisión.")
    end

    rescue ActiveRecord::RecordInvalid => e

    @users = @epidemiological_surveillance_program.surveillance_workers.where(status: :active).includes(:user).map(&:user).sort_by { |user| user.name.to_s.downcase }
    @questions = @surveillance_survey.surveillance_questions.where(active: true).includes(:surveillance_question_options).order(:position)
    @surveillance_survey_response = e.record.respond_to?(:surveillance_survey_response) ? e.record.surveillance_survey_response : @surveillance_survey.surveillance_survey_responses.new

    flash.now[:alert] = "No fue posible registrar la encuesta. Revise la información e inténtelo nuevamente."
    render :new, status: :unprocessable_entity
 
  end

  private


  def set_epidemiological_surveillance_program
    @epidemiological_surveillance_program = EpidemiologicalSurveillanceProgram.find(params[:epidemiological_surveillance_program_id])
  end

  def set_surveillance_survey
    @surveillance_survey = @epidemiological_surveillance_program.surveillance_surveys.find(params[:surveillance_survey_id])
  end
end