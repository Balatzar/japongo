import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input", "result", "meaning", "englishMeaning", "kanji", "nextButton", "progressBar", "progressText", "createCardButton" ]
  static values = {
    wordId: Number,
    sessionId: Number,
    totalWords: Number,
    currentIndex: Number
  }

  connect() {
    this.focusInput()
    this.updateProgress()
  }

  focusInput() {
    this.inputTarget.focus()
  }

  updateProgress() {
    const progress = (this.currentIndexValue / this.totalWordsValue) * 100
    this.progressBarTarget.style.width = `${progress}%`
    this.progressTextTarget.textContent = `Word ${this.currentIndexValue + 1} of ${this.totalWordsValue}`
  }

  checkAnswer(event) {
    event.preventDefault()
    const answer = this.inputTarget.value.trim().toLowerCase()
    
    fetch(`/word_game_sessions/${this.sessionIdValue}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
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
      
      this.englishMeaningTarget.textContent = data.english_meaning
      this.kanjiTarget.textContent = data.kanji
      this.meaningTarget.classList.remove("hidden")
      this.nextButtonTarget.classList.remove("hidden")
      this.createCardButtonTarget.classList.remove("hidden")
      this.nextButtonTarget.focus()

      if (data.completed) {
        this.nextButtonTarget.textContent = "See Results"
      }

      this.currentIndexValue += 1
      this.updateProgress()
    })
  }

  nextWord(event) {
    if (event.type === "keydown" && event.key !== "Enter") {
      return
    }
    Turbo.visit(window.location.href, { action: "replace" })
  }

  handleKeydown(event) {
    if (event.key === "Enter" && !this.nextButtonTarget.classList.contains("hidden")) {
      this.nextWord(event)
    }
  }
}