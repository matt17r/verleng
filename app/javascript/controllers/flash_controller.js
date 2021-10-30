import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
  }

  close() {
    if (this.element) {
      this.element.remove()
    }
  }
}
