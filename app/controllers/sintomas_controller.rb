class SintomasController < ApplicationController

  before_action :set_epidemiological_surveillance_program
  before_action :set_surveillance_worker
  before_action :set_sintoma, only: [:edit, :update]

  def new
    if @surveillance_worker.sintoma.present?
      redirect_to(epidemiological_surveillance_program_surveillance_worker_path(@epidemiological_surveillance_program, @surveillance_worker), alert: "El trabajador ya tiene un registro de síntomas.")
      return
    end

    @sintoma = @surveillance_worker.build_sintoma
  end


  def create
    if @surveillance_worker.sintoma.present?
      redirect_to(epidemiological_surveillance_program_surveillance_worker_path(@epidemiological_surveillance_program, @surveillance_worker), alert: "El trabajador ya tiene un registro de síntomas.")
      return
    end

    @sintoma = @surveillance_worker.build_sintoma(sintoma_params)

    if @sintoma.save
      redirect_to(epidemiological_surveillance_program_surveillance_worker_path(@epidemiological_surveillance_program, @surveillance_worker), notice: "El registro de síntomas fue creado correctamente.")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @sintoma.update(sintoma_params)
      redirect_to(epidemiological_surveillance_program_surveillance_worker_path(@epidemiological_surveillance_program, @surveillance_worker), notice: "El registro de síntomas fue actualizado correctamente.")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def set_epidemiological_surveillance_program
    @epidemiological_surveillance_program = EpidemiologicalSurveillanceProgram.find(params[:epidemiological_surveillance_program_id])

  end

  def set_surveillance_worker
    @surveillance_worker = @epidemiological_surveillance_program.surveillance_workers.find(params[:surveillance_worker_id])
  end

  def set_sintoma
    @sintoma = @surveillance_worker.sintoma

    unless @sintoma.present?
      redirect_to(epidemiological_surveillance_program_surveillance_worker_path(@epidemiological_surveillance_program, @surveillance_worker), alert: "El trabajador no tiene un registro de síntomas.")
    end
  end

  def sintoma_params
    params.require(:sintoma).permit(
      :fiebre,
      :tos,
      :dolor_garganta,
      :congestion_nasal,
      :dificultad_respirar,
      :dolor_pecho,
      :dolor_cabeza,
      :dolores_musculares,
      :escalofrios,
      :fatiga_cansancio_inusual,
      :nauseas_vomito,
      :diarrea,
      :otro,
      :otro_cual,
      :ninguno_anteriores,
      :incapacidad,
      :contacto_respiratorio,
      :irritacion_asociada_trabajo,
      :accion_sst,
      :seguimiento
    )
  end
end