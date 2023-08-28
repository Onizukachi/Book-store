import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"];

  connect() {
    if (this.hasMessageTarget) {
      setTimeout(() => {
        this.messageTarget.style.display = "none";
      }, 3000); // Скрываем через 3 секунды
    }
  }
}
