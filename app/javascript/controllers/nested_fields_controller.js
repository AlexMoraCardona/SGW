import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template"]

  add(event) {
    event.preventDefault()

    const content = this.templateTarget.innerHTML
      .replace(/NEW_RECORD/g, new Date().getTime())

    this.containerTarget.insertAdjacentHTML("beforeend", content)

    this.updatePositions()
  }

  remove(event) {
    event.preventDefault()

    const row = event.target.closest("[data-nested-fields-row]")

    if (!row) return

    const destroyField = row.querySelector(
      'input[name*="[_destroy]"]'
    )

    if (destroyField) {
      destroyField.value = "1"
      row.style.display = "none"
    } else {
      row.remove()
    }

    this.updatePositions()
  }

  updatePositions() {
    const rows = this.containerTarget.querySelectorAll(
      '[data-nested-fields-row]:not([style*="display: none"])'
    )

    rows.forEach((row, index) => {
      const positionField = row.querySelector(
        'input[name*="[position]"]'
      )

      if (positionField) {
        positionField.value = index
      }
    })
  }
}