// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "./controllers"
import "popper"
import "bootstrap" 
import "chartkick"
import "Chart.bundle"
import "chartkick/chart.js"
import "direct_uploads"
import "trix"
import "@rails/actiontext"

document.addEventListener("turbo:load", () => {
  const dialogs = document.querySelectorAll(".modal");

  dialogs.forEach((dialog) => {
    dialog.addEventListener("turbo:frame-missing", async (e) => {
      const { ok, url } = e.detail.response;

      if (ok) {
        e.preventDefault();
        e.detail.visit(url, { action: "replace" });
      }
    });
  });
});


import { StreamActions } from "@hotwired/turbo"

StreamActions.console_log = function() {
    const message = this.getAttribute("message")
    console.log(message)
}
        

