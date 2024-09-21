import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["key"]

  connect() {
    console.log("Hiragana keyboard controller connected")
  }

  inputHiragana(event) {
    const character = event.currentTarget.dataset.character
    const customEvent = new CustomEvent("hiragana-keyboard:input", {
      detail: { character: character },
      bubbles: true
    })
    this.element.dispatchEvent(customEvent)
  }
}