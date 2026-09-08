class SurveillanceConfigurationsController < ApplicationController

  before_action :set_surveillance_configuration, only: %i[show edit update destroy]

  def index
    @surveillance_configurations = SurveillanceConfiguration.includes(:surveillance_configuration_questions).order(:name)
  end

  def show
    @surveillance_configuration_questions = @surveillance_configuration.surveillance_configuration_questions.includes(:surveillance_configuration_question_options).order(position: :asc) 
  end

  def new
    @surveillance_configuration = SurveillanceConfiguration.new
  end

  def create
    @surveillance_configuration = SurveillanceConfiguration.new(surveillance_configuration_params)

    if @surveillance_configuration.save
      redirect_to surveillance_configurations_path, notice: "La configuración SVE fue creada correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @surveillance_configuration.update(surveillance_configuration_params)
      redirect_to surveillance_configurations_path, notice: "La configuración SVE fue actualizada correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @surveillance_configuration.destroy
      redirect_to surveillance_configurations_path, notice: "La configuración SVE fue eliminada correctamente."
    else
      redirect_to surveillance_configurations_path, alert: "No fue posible eliminar la configuración SVE."
    end
  end

  private

  def set_surveillance_configuration
    @surveillance_configuration = SurveillanceConfiguration.find(params[:id])
  end

  def surveillance_configuration_params
    params.require(:surveillance_configuration).permit(
      :name,
      :status
    )
  end

end
