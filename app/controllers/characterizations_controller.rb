class CharacterizationsController < ApplicationController

  before_action :set_epidemiological_surveillance_program
  before_action :set_surveillance_worker
  before_action :set_characterization,
                only: [:edit, :update]


  def new

    if @surveillance_worker.characterization.present?

      redirect_to(
        epidemiological_surveillance_program_surveillance_worker_path(
          @epidemiological_surveillance_program,
          @surveillance_worker
        ),
        alert: "El trabajador ya tiene una caracterización registrada."
      )

      return
    end

    @characterization =
      @surveillance_worker.build_characterization

  end


  def create

    if @surveillance_worker.characterization.present?

      redirect_to(
        epidemiological_surveillance_program_surveillance_worker_path(
          @epidemiological_surveillance_program,
          @surveillance_worker
        ),
        alert: "El trabajador ya tiene una caracterización registrada."
      )

      return
    end


    @characterization =
      @surveillance_worker.build_characterization(
        characterization_params
      )


    if @characterization.save

      redirect_to(
        epidemiological_surveillance_program_surveillance_worker_path(
          @epidemiological_surveillance_program,
          @surveillance_worker
        ),
        notice: "La caracterización fue registrada correctamente."
      )

    else

      render :new,
             status: :unprocessable_entity

    end

  end


  def edit
  end


  def update

    if @characterization.update(characterization_params)

      redirect_to(
        epidemiological_surveillance_program_surveillance_worker_path(
          @epidemiological_surveillance_program,
          @surveillance_worker
        ),
        notice: "La caracterización fue actualizada correctamente."
      )

    else

      render :edit,
             status: :unprocessable_entity

    end

  end


  private


  def set_epidemiological_surveillance_program

    @epidemiological_surveillance_program =
      EpidemiologicalSurveillanceProgram.find(
        params[:epidemiological_surveillance_program_id]
      )

  end


  def set_surveillance_worker

    @surveillance_worker =
      @epidemiological_surveillance_program.surveillance_workers.find(
        params[:surveillance_worker_id]
      )

  end


  def set_characterization

    @characterization =
      @surveillance_worker.characterization

    unless @characterization.present?

      redirect_to(
        epidemiological_surveillance_program_surveillance_worker_path(
          @epidemiological_surveillance_program,
          @surveillance_worker
        ),
        alert: "El trabajador no tiene una caracterización registrada."
      )

    end

  end


  def characterization_params

    params.require(:characterization).permit(
      :pve_group,
      :principal_exposure,
      :frequency,
      :respirator_required,
      :characterization_status
    )

  end

end