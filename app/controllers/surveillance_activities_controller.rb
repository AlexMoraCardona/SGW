class SurveillanceActivitiesController < ApplicationController
  before_action :set_epidemiological_surveillance_program
  before_action :set_surveillance_activity, only: [:show, :edit, :update, :destroy]

  def index
    @surveillance_activities = @epidemiological_surveillance_program.surveillance_activities.includes(:responsible).order(planned_date: :asc, created_at: :asc)
  end

  def show
  end

  def new
    @surveillance_activity =  @epidemiological_surveillance_program.surveillance_activities.new
  end

  def create
    @surveillance_activity =  @epidemiological_surveillance_program.surveillance_activities.new(surveillance_activity_params)

    if @surveillance_activity.save
      redirect_to(epidemiological_surveillance_program_surveillance_activity_path(@epidemiological_surveillance_program, @surveillance_activity), notice: "La actividad fue creada correctamente.")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @surveillance_activity.update(surveillance_activity_params)
      redirect_to(epidemiological_surveillance_program_surveillance_activity_path(@epidemiological_surveillance_program, @surveillance_activity), notice: "La actividad fue actualizada correctamente.")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @surveillance_activity.destroy
      redirect_to(epidemiological_surveillance_program_surveillance_activities_path(@epidemiological_surveillance_program), notice: "La actividad fue eliminada correctamente.")
    else
      redirect_to(epidemiological_surveillance_program_surveillance_activities_path(@epidemiological_surveillance_program), alert: "No fue posible eliminar la actividad.")
    end
  end

  private

  def set_epidemiological_surveillance_program
    @epidemiological_surveillance_program = EpidemiologicalSurveillanceProgram.find(params[:epidemiological_surveillance_program_id])
  end

  def set_surveillance_activity
    @surveillance_activity = @epidemiological_surveillance_program.surveillance_activities.find(params[:id])
  end

  def surveillance_activity_params
    params.require(:surveillance_activity).permit(
      :name,
      :description,
      :responsible_id,
      :planned_date,
      :execution_date,
      :status,
      :observations
    )
  end
end