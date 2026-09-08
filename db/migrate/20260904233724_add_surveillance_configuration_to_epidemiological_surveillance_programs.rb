class AddSurveillanceConfigurationToEpidemiologicalSurveillancePrograms < ActiveRecord::Migration[7.0]
  def change
    add_reference :epidemiological_surveillance_programs,
                  :surveillance_configuration,
                  null: true,
                  foreign_key: true,
                  index: {
                    name: "idx_sve_programs_configuration"
                  }
  end
end

