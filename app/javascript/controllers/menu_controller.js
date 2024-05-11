import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['dato']
  buscar() {

    const info = this.datoTarget.value
    console.log(this.datoTarget.value)
    
  }

  get info(){
    return this.datoTarget.value
  }
}