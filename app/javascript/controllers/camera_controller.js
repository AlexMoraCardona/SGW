import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["video"]

  connect() {
    console.log("CAMERA CONTROLLER FUNCIONANDO")
  }

  async startCamera() {

    try {

      const stream = await navigator.mediaDevices.getUserMedia({
        video: true,
        audio: false
      })

      this.videoTarget.srcObject = stream

      await this.videoTarget.play()

      console.log("Cámara iniciada")

    } catch(error) {

      console.error(error)
      alert(error.message)

    }

  }

}