import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application


export { application }

// application.js
import "trix"
import "@rails/actiontext"
