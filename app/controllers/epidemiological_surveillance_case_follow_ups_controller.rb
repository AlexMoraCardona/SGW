class EpidemiologicalSurveillanceCaseFollowUpsController < ApplicationController

  before_action :set_epidemiological_surveillance_program
  before_action :set_epidemiological_surveillance_case

  before_action :set_follow_up, only: %i[show edit update destroy destroy_attachment]

  def index
    @follow_ups =  @epidemiological_surveillance_case.follow_ups.includes(:user).order(follow_up_date: :desc)
  end

  def show
    @follow_up = @epidemiological_surveillance_case.follow_ups.find(params[:id])
  end

  def new
    @follow_up =  @epidemiological_surveillance_case.follow_ups.new
    @follow_up.follow_up_date = Time.current
    @follow_up.user_id = Current.user.id if Current.user
  end

  def create
    ActiveRecord::Base.transaction do
      @follow_up = @epidemiological_surveillance_case.follow_ups.new(follow_up_params)
      @follow_up.user_id ||= Current.user.id if Current.user
      @follow_up.save!

      # ------------------------------------------------------
      # ACTUALIZAR ESTADO DEL CASO
      # ------------------------------------------------------
      update_case_status_from_follow_up!
    end

    redirect_to(epidemiological_surveillance_program_epidemiological_surveillance_case_path(@epidemiological_surveillance_program, @epidemiological_surveillance_case), notice: "El seguimiento fue registrado correctamente.")

    rescue ActiveRecord::RecordInvalid

      flash.now[:alert] = "No fue posible registrar el seguimiento. Revise la información e inténtelo nuevamente."
      render :new, status: :unprocessable_entity
  end

  # ==========================================================
  # EDITAR SEGUIMIENTO
  # ==========================================================

  def edit
  end

  # ==========================================================
  # ACTUALIZAR SEGUIMIENTO
  # ==========================================================
  def update
    ActiveRecord::Base.transaction do
      # Estado del caso antes de modificar el seguimiento
      previous_case_status = @epidemiological_surveillance_case.status

      @follow_up.update!(follow_up_params)
      # ------------------------------------------------------
      # ACTUALIZAR ESTADO DEL CASO
      # ------------------------------------------------------
      update_case_status_from_follow_up!(previous_status: previous_case_status)
    end

    redirect_to(epidemiological_surveillance_program_epidemiological_surveillance_case_path(@epidemiological_surveillance_program, @epidemiological_surveillance_case), notice: "El seguimiento fue actualizado correctamente.")
    rescue ActiveRecord::RecordInvalid
    flash.now[:alert] = "No fue posible actualizar el seguimiento."
    render :edit, status: :unprocessable_entity
  end

  # ==========================================================
  # ELIMINAR SEGUIMIENTO
  # ==========================================================
  def destroy
    @follow_up.destroy!

    redirect_to(epidemiological_surveillance_program_epidemiological_surveillance_case_path(@epidemiological_surveillance_program, @epidemiological_surveillance_case), notice: "El seguimiento fue eliminado correctamente.")

    rescue ActiveRecord::RecordNotDestroyed

    redirect_to(epidemiological_surveillance_program_epidemiological_surveillance_case_path(@epidemiological_surveillance_program, @epidemiological_surveillance_case), alert: "No fue posible eliminar el seguimiento.")
  end

  # ==========================================================
  # ELIMINAR ARCHIVO
  # ==========================================================
  def destroy_attachment
    file = @follow_up.follow_up_files.find(params[:attachment_id])

    file.purge
    redirect_to(epidemiological_surveillance_program_epidemiological_surveillance_case_epidemiological_surveillance_case_follow_up_path(@epidemiological_surveillance_program, @epidemiological_surveillance_case, @follow_up), notice: "El archivo fue eliminado correctamente.")

    rescue ActiveRecord::RecordNotFound

    redirect_to(epidemiological_surveillance_program_epidemiological_surveillance_case_epidemiological_surveillance_case_follow_up_path(@epidemiological_surveillance_program, @epidemiological_surveillance_case, @follow_up), alert: "No fue posible encontrar el archivo.")
  end

  private

  def update_case_status_from_follow_up!(previous_status: nil)
    new_status = @follow_up.status
    return if new_status.blank?
    previous_status ||=  @epidemiological_surveillance_case.status

    # --------------------------------------------------------
    # Si el estado realmente cambió
    # --------------------------------------------------------
    if previous_status != new_status
      @epidemiological_surveillance_case.status = new_status

      # ------------------------------------------------------
      # FECHA DE CIERRE
      # ------------------------------------------------------
      if new_status == "closed"
        @epidemiological_surveillance_case.closed_at ||= Time.current
      else
        @epidemiological_surveillance_case.closed_at = nil
      end
      @epidemiological_surveillance_case.save!

      # ------------------------------------------------------
      # HISTORIAL DEL CAMBIO
      # ------------------------------------------------------

      EpidemiologicalSurveillanceCaseHistory.create!(
        epidemiological_surveillance_case:
          @epidemiological_surveillance_case,
        user:
          @follow_up.user || Current.user,
        previous_status:
          EpidemiologicalSurveillanceCase
            .statuses[previous_status],
        new_status:
          EpidemiologicalSurveillanceCase
            .statuses[new_status],
        changed_at:
          Time.current,
        observations:
          @follow_up.observations.presence ||
          @follow_up.result
      )
    else
      # ------------------------------------------------------
      # Aunque no cambie el estado, controlar closed_at
      # ------------------------------------------------------
      if new_status == "closed"
        @epidemiological_surveillance_case.update!(closed_at: @epidemiological_surveillance_case.closed_at || Time.current)
      elsif @epidemiological_surveillance_case.closed_at.present?
        @epidemiological_surveillance_case.update!(closed_at: nil)
      end
    end

  end


  # ==========================================================
  # PROGRAMA
  # ==========================================================

  def set_epidemiological_surveillance_program
    @epidemiological_surveillance_program = EpidemiologicalSurveillanceProgram.find(params[:epidemiological_surveillance_program_id])

  end

  # ==========================================================
  # CASO
  # ==========================================================
  def set_epidemiological_surveillance_case
    @epidemiological_surveillance_case = @epidemiological_surveillance_program.epidemiological_surveillance_cases.find(params[:epidemiological_surveillance_case_id])

  end

  # ==========================================================
  # SEGUIMIENTO
  # ==========================================================
  def set_follow_up
    @follow_up = @epidemiological_surveillance_case.follow_ups.find(params[:id])

  end

  # ==========================================================
  # PARÁMETROS
  # ==========================================================
  def follow_up_params
    params.require(
      :epidemiological_surveillance_case_follow_up
    ).permit(
      :follow_up_date,
      :follow_up_type,
      :status,
      :result,
      :observations,
      :next_follow_up_date,
      follow_up_files: []
    )
  end

end