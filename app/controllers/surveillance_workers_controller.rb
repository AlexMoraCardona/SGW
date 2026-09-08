class SurveillanceWorkersController < ApplicationController

  before_action :set_epidemiological_surveillance_program
  before_action :set_surveillance_worker, only: %i[show edit update destroy]

  def index
    @surveillance_workers = @epidemiological_surveillance_program.surveillance_workers.includes(:user).order(status: :asc, entry_date: :desc)
  end

  def show
    @characterization = @surveillance_worker.characterization
  end

  def new
    @surveillance_worker = @epidemiological_surveillance_program.surveillance_workers.new
    @surveillance_worker.status = :active
    @surveillance_worker.entry_date = Date.current
  end

  def create
    @surveillance_worker =  @epidemiological_surveillance_program.surveillance_workers.new(surveillance_worker_params)

    if @surveillance_worker.save
      redirect_to(epidemiological_surveillance_program_surveillance_workers_path(@epidemiological_surveillance_program), notice: "El trabajador fue vinculado correctamente al programa SVE.")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @surveillance_worker.update(surveillance_worker_params)
      redirect_to(epidemiological_surveillance_program_surveillance_workers_path(@epidemiological_surveillance_program), notice: "La información del trabajador fue actualizada correctamente.")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @surveillance_worker.destroy
      redirect_to(epidemiological_surveillance_program_surveillance_workers_path(@epidemiological_surveillance_program), notice: "El trabajador fue retirado del programa SVE.")
    else
      redirect_to(epidemiological_surveillance_program_surveillance_workers_path(@epidemiological_surveillance_program), alert: "No fue posible retirar el trabajador.")
    end
  end

  private
    def set_epidemiological_surveillance_program
        @epidemiological_surveillance_program = EpidemiologicalSurveillanceProgram.find(params[:epidemiological_surveillance_program_id])
    end

    def set_surveillance_worker
      @surveillance_worker = @epidemiological_surveillance_program.surveillance_workers.find(params[:id])
    end

    def surveillance_worker_params
        params.require(
          :surveillance_worker
        ).permit(
          :user_id,
          :status,
          :entry_date,
          :exit_date,
          :observations
        )
    end

end