import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

    static targets = [
        "workAccident",
        "mortalAccident",
        "occupationalDisease",
        "accidentDetails",
        "accidentField",
        "diseaseDetails",
        "diseaseField"
    ]


    connect() {
        this.toggleDetails()
        this.toggleDisease()
    }


    // ============================================================
    // ACCIDENTE DE TRABAJO / ACCIDENTE MORTAL
    // ============================================================
    //
    // Activa los campos del accidente cuando:
    // Accidente de trabajo = SI
    // O
    // Accidente mortal = SI
    //
    // Además:
    // Si alguno de los dos es SI,
    // Enfermedad laboral automáticamente pasa a NO.
    //
    toggleDetails() {

        const workAccident =
            this.workAccidentTargets.some(
                element => element.checked && element.value === "1"
            )

        const mortalAccident =
            this.mortalAccidentTargets.some(
                element => element.checked && element.value === "1"
            )


        const enableFields =
            workAccident || mortalAccident


        // Mostrar u ocultar detalles del accidente
        this.accidentDetailsTarget.classList.toggle(
            "d-none",
            !enableFields
        )


        // Activar o desactivar campos relacionados
        this.accidentFieldTargets.forEach(field => {

            field.disabled = !enableFields

            if (!enableFields) {
                field.value = ""
            }

        })


        // Si accidente de trabajo o accidente mortal = SI
        // Enfermedad laboral = NO
        if (enableFields) {

            const occupationalDiseaseNo =
                this.occupationalDiseaseTargets.find(
                    element => element.value === "0"
                )

            if (occupationalDiseaseNo) {
                occupationalDiseaseNo.checked = true
            }


            // Ocultar detalles de enfermedad laboral
            this.diseaseDetailsTarget.classList.add("d-none")


            // Deshabilitar campos de enfermedad
            this.diseaseFieldTargets.forEach(field => {

                field.disabled = true
                field.value = ""

            })
        }
    }


    // ============================================================
    // ENFERMEDAD LABORAL
    // ============================================================
    //
    // Activa los campos de la enfermedad cuando:
    // Enfermedad laboral = SI
    //
    // Además:
    // Si Enfermedad laboral = SI,
    // Accidente de trabajo = NO
    // Accidente mortal = NO
    //
    toggleDisease() {

        const occupationalDisease =
            this.occupationalDiseaseTargets.some(
                element => element.checked && element.value === "1"
            )


        // Mostrar u ocultar detalles de enfermedad
        this.diseaseDetailsTarget.classList.toggle(
            "d-none",
            !occupationalDisease
        )


        // Activar o desactivar campos de enfermedad
        this.diseaseFieldTargets.forEach(field => {

            field.disabled = !occupationalDisease

            if (!occupationalDisease) {
                field.value = ""
            }

        })


        // Si enfermedad laboral = SI
        // Accidente de trabajo = NO
        // Accidente mortal = NO
        if (occupationalDisease) {

            const workAccidentNo =
                this.workAccidentTargets.find(
                    element => element.value === "0"
                )

            const mortalAccidentNo =
                this.mortalAccidentTargets.find(
                    element => element.value === "0"
                )


            if (workAccidentNo) {
                workAccidentNo.checked = true
            }


            if (mortalAccidentNo) {
                mortalAccidentNo.checked = true
            }


            // Ocultar detalles de accidente
            this.accidentDetailsTarget.classList.add("d-none")


            // Deshabilitar campos de accidente
            this.accidentFieldTargets.forEach(field => {

                field.disabled = true
                field.value = ""

            })
        }
    }


    // ============================================================
    // EVENTO AL CAMBIAR ACCIDENTE DE TRABAJO
    // ============================================================

    changeWorkAccident() {

        this.toggleDetails()
        this.toggleDisease()

    }


    // ============================================================
    // EVENTO AL CAMBIAR ACCIDENTE MORTAL
    // ============================================================

    changeMortalAccident() {

        this.toggleDetails()
        this.toggleDisease()

    }


    // ============================================================
    // EVENTO AL CAMBIAR ENFERMEDAD LABORAL
    // ============================================================

    changeOccupationalDisease() {

        this.toggleDisease()
        this.toggleDetails()

    }


    // ============================================================
    // INCAPACIDAD LABORAL / INCAPACIDAD COMÚN
    // ============================================================

    toggleLaboralInhability(event) {

        if (event.target.value === "1" && event.target.checked) {

            const commonNo = this.element.querySelector(
                'input[name="event[common_inhability]"][value="0"]'
            )


            if (commonNo) {
                commonNo.checked = true
            }

        }

    }


    toggleCommonInhability(event) {

        if (event.target.value === "1" && event.target.checked) {

            const laboralNo = this.element.querySelector(
                'input[name="event[laboral_inhability]"][value="0"]'
            )


            if (laboralNo) {
                laboralNo.checked = true
            }

        }

    }

}
