import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["grid", "input", "message"]
  static values = {
    grid: Array
  }

  connect() {
    console.log("Crossword game controller connected")
    this.initializeGame()
  }

  initializeGame() {
    console.log("Initializing game")
    this.updateInputFields()
    this.updateMessage("Start solving the crossword!")
    console.log("Grid value:", this.gridValue)
  }

  updateInputFields() {
    console.log("Updating input fields")
    const inputs = this.gridTarget.querySelectorAll('input')
    inputs.forEach((input, index) => {
      input.dataset.action = "input->crossword-game#checkInput keydown->crossword-game#handleKeydown"
      input.dataset.index = index
    })
    console.log("Input fields updated")
  }

  handleKeydown(event) {
    console.log("Keydown event:", event.key)
    if (event.key === "Backspace" && event.target.value === "") {
      const prevInput = event.target.previousElementSibling
      if (prevInput && prevInput.tagName === "INPUT") {
        console.log("Moving focus to previous input")
        prevInput.focus()
      }
    } else if (event.key.length === 1 && event.target.value !== "") {
      const nextInput = event.target.nextElementSibling
      if (nextInput && nextInput.tagName === "INPUT") {
        console.log("Moving focus to next input")
        nextInput.focus()
      }
    }
  }

  checkInput(event) {
    const input = event.target
    const row = parseInt(input.dataset.row)
    const col = parseInt(input.dataset.col)
    console.log(`Checking input at row ${row}, col ${col}`)
    
    if (this.gridValue[row][col] === " ") {
      console.error("Trying to input into a black cell")
      input.value = ""
      return
    }

    console.log("Input value:", input.value)
    console.log("Expected value:", this.gridValue[row][col])

    if (this.isGridFilled()) {
      console.log("Grid is filled, validating")
      this.validateGrid()
    }
  }

  isGridFilled() {
    const inputs = this.gridTarget.querySelectorAll('input')
    const filled = Array.from(inputs).every(input => input.value !== "")
    console.log("Is grid filled:", filled)
    return filled
  }

  validateGrid() {
    console.log("Validating grid")
    const inputs = this.gridTarget.querySelectorAll('input')
    let isValid = true

    inputs.forEach((input) => {
      const row = parseInt(input.dataset.row)
      const col = parseInt(input.dataset.col)
      
      if (this.gridValue[row][col] !== " ") {
        const inputValue = input.value.toLowerCase()
        const expectedValue = this.gridValue[row][col].toLowerCase()
        console.log(`Validating cell (${row}, ${col}):`, inputValue, "Expected:", expectedValue)
        
        if (inputValue === expectedValue) {
          input.classList.add('correct')
          input.classList.remove('incorrect')
        } else {
          isValid = false
          input.classList.add('incorrect')
          input.classList.remove('correct')
        }
      }
    })

    console.log("Grid validation result:", isValid)

    if (isValid) {
      this.gameWon()
    } else {
      this.updateMessage("There are some incorrect letters. Keep trying!")
    }
  }

  gameWon() {
    console.log("Game won!")
    this.updateMessage("Congratulations! You've completed the crossword!")
    this.gridTarget.querySelectorAll('input').forEach(input => {
      input.disabled = true
    })
  }

  updateMessage(message) {
    console.log("Updating message:", message)
    this.messageTarget.textContent = message
  }
}