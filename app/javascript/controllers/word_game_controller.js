import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input", "result" ]
  static values = {
    wordId: Number,
    sessionId: Number
  }

  checkAnswer(event) {
    event.preventDefault()
    const answer = this.inputTarget.value.trim().toLowerCase()
    
    fetch(`/word_game_sessions/${this.sessionIdValue}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ word_id: this.wordIdValue, answer: answer })
    })
    .then(response => response.json())
    .then(data => {
      if (data.correct) {
        this.resultTarget.textContent = "Correct!"
        this.resultTarget.classList.add("text-green-500")
      } else {
        this.resultTarget.textContent = `Incorrect. The correct answer was: ${data.correct_answer}`
        this.resultTarget.classList.add("text-red-500")
      }
      
      // Refresh the page after a short delay to show the next word
      setTimeout(() => {
        Turbo.visit(window.location.href, { action: "replace" })
      }, 2000)
    })
  }
}