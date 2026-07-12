import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = [
    "video",
    "canvas",
    "preview",
    "photo",
    "button"
  ]

  connect() {

    console.log("Camera Controller iniciado")

    this.stream = null
    this.estado = "inicial"

    this.videoTarget.style.display = "none"
    this.previewTarget.style.display = "none"

    this.actualizarBoton()
  }

  disconnect() {
    this.detenerCamara()
  }

  async tomarFotografia() {

    switch (this.estado) {

      // Primer clic: abrir cámara
      case "inicial":

        await this.iniciarCamara()

        this.videoTarget.style.display = "block"
        this.previewTarget.style.display = "none"

        this.estado = "camara"
        this.actualizarBoton()

        break


      // Segundo clic: capturar
      case "camara":

        this.capturar()

        this.estado = "foto"
        this.actualizarBoton()

        break


      // Tercer clic: tomar otra foto
      case "foto":

        this.photoTarget.value = ""
        this.previewTarget.src = ""

        this.previewTarget.style.display = "none"
        this.videoTarget.style.display = "block"

        await this.iniciarCamara()

        this.estado = "camara"
        this.actualizarBoton()

        break

    }

  }

  async iniciarCamara() {

    if (this.stream) return

    try {

      this.stream = await navigator.mediaDevices.getUserMedia({
        video: {
          facingMode: "environment"
        },
        audio: false
      })

      this.videoTarget.srcObject = this.stream

      await this.videoTarget.play()

      console.log("Cámara iniciada")

    } catch (error) {

      console.error(error)

      alert("No fue posible acceder a la cámara.")

    }

  }

  capturar() {

    this.canvasTarget.width = this.videoTarget.videoWidth
    this.canvasTarget.height = this.videoTarget.videoHeight

    const contexto = this.canvasTarget.getContext("2d")

    contexto.drawImage(
      this.videoTarget,
      0,
      0,
      this.canvasTarget.width,
      this.canvasTarget.height
    )

    const imagen = this.canvasTarget.toDataURL("image/jpeg", 0.9)

    this.previewTarget.src = imagen
    this.photoTarget.value = imagen

    this.videoTarget.style.display = "none"
    this.previewTarget.style.display = "block"

    this.detenerCamara()

  }

  detenerCamara() {

    if (!this.stream) return

    this.stream.getTracks().forEach(track => track.stop())

    this.videoTarget.pause()
    this.videoTarget.srcObject = null

    this.stream = null

    console.log("Cámara detenida")

  }

  actualizarBoton() {

    this.buttonTarget.classList.remove(
      "btn-primary",
      "btn-danger",
      "btn-success"
    )

    switch (this.estado) {

      case "inicial":

        this.buttonTarget.classList.add("btn-primary")
        this.buttonTarget.innerHTML = "📷 Tomar fotografía"

        break

      case "camara":

        this.buttonTarget.classList.add("btn-danger")
        this.buttonTarget.innerHTML = "📸 Capturar"

        break

      case "foto":

        this.buttonTarget.classList.add("btn-success")
        this.buttonTarget.innerHTML = "🔄 Tomar otra fotografía"

        break

    }

  }

}