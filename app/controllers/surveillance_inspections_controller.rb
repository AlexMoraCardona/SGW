class SurveillanceInspectionsController < ApplicationController
  before_action :set_epidemiological_surveillance_program
  before_action :set_surveillance_inspection, only: [:show, :edit, :update, :destroy]
  before_action :set_company_areas, only: [:new, :create, :edit, :update]

  def index
    @surveillance_inspections = @epidemiological_surveillance_program.surveillance_inspections.includes(:company_area).order(fecha: :desc)
  end

  def show
  end

  def new
    @surveillance_inspection =  @epidemiological_surveillance_program.surveillance_inspections.build
    @surveillance_inspection.fecha = Date.current
    @surveillance_inspection.estado = :abierta
  end

  def create
    @surveillance_inspection = @epidemiological_surveillance_program.surveillance_inspections.build(surveillance_inspection_params)

    if @surveillance_inspection.save
      redirect_to(epidemiological_surveillance_program_surveillance_inspections_path(@epidemiological_surveillance_program), notice: "La inspección fue registrada correctamente.") 
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @surveillance_inspection.update(surveillance_inspection_params)
      redirect_to(epidemiological_surveillance_program_surveillance_inspections_path(@epidemiological_surveillance_program), notice: "La inspección fue actualizada correctamente.")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update
    if @surveillance_inspection.update(surveillance_inspection_params)
      redirect_to(epidemiological_surveillance_program_surveillance_inspection_path(@epidemiological_surveillance_program, @surveillance_inspection), notice: "La inspección fue actualizada correctamente.")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @surveillance_inspection.destroy

    redirect_to(epidemiological_surveillance_program_surveillance_inspections_path(@epidemiological_surveillance_program), notice: "La inspección fue eliminada correctamente.")
  end

  private

  def set_epidemiological_surveillance_program
    @epidemiological_surveillance_program = EpidemiologicalSurveillanceProgram.find(params[:epidemiological_surveillance_program_id])
  end

  def set_surveillance_inspection
    @surveillance_inspection =  @epidemiological_surveillance_program.surveillance_inspections.find(params[:id])
  end

  def set_company_areas
    @company_areas =  CompanyArea.where(entity_id: @epidemiological_surveillance_program.entity_id).order(:name)
  end

  def surveillance_inspection_params
    params.require(:surveillance_inspection).permit(
      :fecha,
      :company_area_id,
      :inspector,
      :fuente_emision,
      :control_fuente,
      :extraccion_operativa,
      :sin_obstrucciones,
      :mantenimiento_vigente,
      :fugas_derrames_controlados,
      :almacenamiento_adecuado,
      :epp_disponible,
      :uso_adecuado,
      :ventilacion_areas_comunes,
      :hallazgo_critico,
      :accion,
      :responsable,
      :fecha_limite,
      :estado
    )
  end
end