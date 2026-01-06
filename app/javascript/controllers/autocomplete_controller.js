import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "list"]

  search() {
    const word = this.inputTarget.value
    if (word.length < 1) {
      this.listTarget.innerHTML = ""
      return
    }

    fetch(`/search/autocomplete?word=${encodeURIComponent(word)}`)
      .then(response => response.json())
      .then(data => {
        this.listTarget.innerHTML = ""
        data.forEach(item => {
          const option = document.createElement("option")
          option.value = item
          this.listTarget.appendChild(option)
        })
      })
  }
}