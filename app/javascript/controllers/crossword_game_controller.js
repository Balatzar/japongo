import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["grid", "input", "message", "clues"];
  static values = {
    grid: Array,
    answers: Array,
  };

  connect() {
    console.log("Crossword game controller connected");
    this.initializeGame();
    this.addHiraganaKeyboardListener();
    this.currentWordDirection = null;
    this.currentWordStartRow = null;
    this.currentWordStartCol = null;
    this.lastClickedCell = null;
  }

  initializeGame() {
    console.log("Initializing game");
    this.updateInputFields();
    this.updateMessage("Start solving the crossword!");
    console.log("Grid value:", this.gridValue);
  }

  updateInputFields() {
    console.log("Updating input fields");
    const inputs = this.gridTarget.querySelectorAll("input");
    inputs.forEach((input, index) => {
      input.dataset.action =
        "input->crossword-game#checkInput keydown->crossword-game#handleKeydown focus->crossword-game#handleFocus click->crossword-game#handleCellClick";
      input.dataset.index = index;
    });
    console.log("Input fields updated");
  }

  handleKeydown(event) {
    console.log("Keydown event:", event.key);
    if (event.key === "Backspace" && event.target.value === "") {
      this.moveToPreviousInput(event.target);
    } else if (event.key.length === 1 && event.target.value !== "") {
      this.moveToNextInput(event.target);
    }
  }

  handleFocus(event) {
    this.currentInput = event.target;
  }

  checkInput(event) {
    const input = event.target;
    const row = parseInt(input.dataset.row);
    const col = parseInt(input.dataset.col);
    console.log(`Checking input at row ${row}, col ${col}`);

    if (this.gridValue[row][col] === " ") {
      console.error("Trying to input into a black cell");
      input.value = "";
      return;
    }

    console.log("Input value:", input.value);
    console.log("Expected value:", this.gridValue[row][col]);

    if (this.isGridFilled()) {
      console.log("Grid is filled, validating");
      this.validateGrid();
    } else {
      this.moveToNextInput(input);
    }
  }

  moveToNextInput(currentInput) {
    if (this.currentWordDirection) {
      const nextInput = this.getNextInputInWord(currentInput);
      if (nextInput) {
        nextInput.focus();
      }
    } else {
      const nextInput = currentInput.nextElementSibling;
      if (nextInput && nextInput.tagName === "INPUT") {
        nextInput.focus();
      }
    }
  }

  moveToPreviousInput(currentInput) {
    if (this.currentWordDirection) {
      const prevInput = this.getPreviousInputInWord(currentInput);
      if (prevInput) {
        prevInput.focus();
      }
    } else {
      const prevInput = currentInput.previousElementSibling;
      if (prevInput && prevInput.tagName === "INPUT") {
        prevInput.focus();
      }
    }
  }

  getNextInputInWord(currentInput) {
    const currentRow = parseInt(currentInput.dataset.row);
    const currentCol = parseInt(currentInput.dataset.col);
    let nextRow = currentRow;
    let nextCol = currentCol;

    if (this.currentWordDirection === "horizontal") {
      nextCol++;
    } else {
      nextRow++;
    }

    return this.gridTarget.querySelector(
      `input[data-row="${nextRow}"][data-col="${nextCol}"]`
    );
  }

  getPreviousInputInWord(currentInput) {
    const currentRow = parseInt(currentInput.dataset.row);
    const currentCol = parseInt(currentInput.dataset.col);
    let prevRow = currentRow;
    let prevCol = currentCol;

    if (this.currentWordDirection === "horizontal") {
      prevCol--;
    } else {
      prevRow--;
    }

    return this.gridTarget.querySelector(
      `input[data-row="${prevRow}"][data-col="${prevCol}"]`
    );
  }

  isGridFilled() {
    const inputs = this.gridTarget.querySelectorAll("input");
    const filled = Array.from(inputs).every((input) => input.value !== "");
    console.log("Is grid filled:", filled);
    return filled;
  }

  validateGrid() {
    console.log("Validating grid");
    const inputs = this.gridTarget.querySelectorAll("input");
    let isValid = true;

    inputs.forEach((input) => {
      const row = parseInt(input.dataset.row);
      const col = parseInt(input.dataset.col);

      if (this.gridValue[row][col] !== " ") {
        const inputValue = input.value.toLowerCase();
        const expectedValue = this.gridValue[row][col].toLowerCase();
        console.log(
          `Validating cell (${row}, ${col}):`,
          inputValue,
          "Expected:",
          expectedValue
        );

        if (inputValue === expectedValue) {
          input.classList.add("correct");
          input.classList.remove("incorrect");
        } else {
          isValid = false;
          input.classList.add("incorrect");
          input.classList.remove("correct");
        }
      }
    });

    console.log("Grid validation result:", isValid);

    if (isValid) {
      this.gameWon();
    } else {
      this.updateMessage("There are some incorrect letters. Keep trying!");
    }
  }

  gameWon() {
    console.log("Game won!");
    this.updateMessage("Congratulations! You've completed the crossword!");
    this.gridTarget.querySelectorAll("input").forEach((input) => {
      input.disabled = true;
    });
  }

  updateMessage(message) {
    console.log("Updating message:", message);
    this.messageTarget.textContent = message;
  }

  getHint() {
    console.log("Getting hint");
    const emptyCells = this.getEmptyCells();
    if (emptyCells.length === 0) {
      this.updateMessage("No empty cells left!");
      return;
    }

    const randomCell =
      emptyCells[Math.floor(Math.random() * emptyCells.length)];
    const input = randomCell.input;
    const row = parseInt(input.dataset.row);
    const col = parseInt(input.dataset.col);
    const correctLetter = this.gridValue[row][col];

    input.value = correctLetter;
    input.classList.add("correct");
    input.dispatchEvent(new Event("input"));

    this.updateMessage("Hint provided! A random cell has been filled.");
  }

  getEmptyCells() {
    const inputs = this.gridTarget.querySelectorAll("input");
    return Array.from(inputs)
      .filter((input) => {
        const row = parseInt(input.dataset.row);
        const col = parseInt(input.dataset.col);
        return this.gridValue[row][col] !== " " && input.value === "";
      })
      .map((input) => ({
        input,
        row: parseInt(input.dataset.row),
        col: parseInt(input.dataset.col),
      }));
  }

  addHiraganaKeyboardListener() {
    document.addEventListener("hiragana-keyboard:input", (event) => {
      if (this.currentInput) {
        this.currentInput.value = event.detail.character;
        this.currentInput.dispatchEvent(new Event("input", { bubbles: true }));
      }
    });
  }

  highlightClueWord(event) {
    console.log("Highlighting clue word");
    const clueElement = event.currentTarget;
    const word = clueElement.dataset.crosswordGameWord;
    this.currentWordDirection = clueElement.dataset.crosswordGameDirection;
    this.currentWordStartRow = parseInt(
      clueElement.dataset.crosswordGameStartRow
    );
    this.currentWordStartCol = parseInt(
      clueElement.dataset.crosswordGameStartCol
    );

    this.highlightWord(
      word,
      this.currentWordDirection,
      this.currentWordStartRow,
      this.currentWordStartCol
    );
    this.highlightClue(clueElement);

    // Focus on the first cell of the word
    const firstInput = this.gridTarget.querySelector(
      `input[data-row="${this.currentWordStartRow}"][data-col="${this.currentWordStartCol}"]`
    );
    if (firstInput) {
      firstInput.focus();
    }
  }

  handleCellClick(event) {
    const input = event.target;
    const row = parseInt(input.dataset.row);
    const col = parseInt(input.dataset.col);
    console.log(`Cell clicked at row ${row}, col ${col}`);

    if (this.gridValue[row][col] === " ") {
      console.error("Clicked on a black cell");
      return;
    }

    const horizontalClue = this.findClueForCell(row, col, "horizontal");
    const verticalClue = this.findClueForCell(row, col, "vertical");

    if (horizontalClue && verticalClue) {
      if (this.lastClickedCell === input) {
        // Toggle between horizontal and vertical
        this.currentWordDirection =
          this.currentWordDirection === "horizontal"
            ? "vertical"
            : "horizontal";
      } else {
        // Default to horizontal on first click
        this.currentWordDirection = "horizontal";
      }
    } else if (horizontalClue) {
      this.currentWordDirection = "horizontal";
    } else if (verticalClue) {
      this.currentWordDirection = "vertical";
    } else {
      console.error("No clue found for this cell");
      return;
    }

    const selectedClue =
      this.currentWordDirection === "horizontal"
        ? horizontalClue
        : verticalClue;
    this.highlightWord(
      selectedClue.word,
      this.currentWordDirection,
      selectedClue.startRow,
      selectedClue.startCol
    );
    this.highlightClue(selectedClue.element);

    this.lastClickedCell = input;
    input.focus();
  }

  findClueForCell(row, col, direction) {
    const clues = this.cluesTarget.querySelectorAll("li");
    for (const clue of clues) {
      const clueDirection = clue.dataset.crosswordGameDirection;
      const startRow = parseInt(clue.dataset.crosswordGameStartRow);
      const startCol = parseInt(clue.dataset.crosswordGameStartCol);
      const word = clue.dataset.crosswordGameWord;

      if (clueDirection === direction) {
        if (
          direction === "horizontal" &&
          row === startRow &&
          col >= startCol &&
          col < startCol + word.length
        ) {
          return { word, startRow, startCol, element: clue };
        } else if (
          direction === "vertical" &&
          col === startCol &&
          row >= startRow &&
          row < startRow + word.length
        ) {
          return { word, startRow, startCol, element: clue };
        }
      }
    }
    return null;
  }

  highlightWord(word, direction, startRow, startCol) {
    // Remove previous highlights
    this.gridTarget.querySelectorAll("input").forEach((input) => {
      input.classList.remove("highlighted");
    });

    // Highlight the cells for the selected word
    for (let i = 0; i < word.length; i++) {
      let row = startRow;
      let col = startCol;

      if (direction === "horizontal") {
        col += i;
      } else {
        row += i;
      }

      const input = this.gridTarget.querySelector(
        `input[data-row="${row}"][data-col="${col}"]`
      );
      if (input) {
        input.classList.add("highlighted");
      }
    }

    this.currentWordDirection = direction;
    this.currentWordStartRow = startRow;
    this.currentWordStartCol = startCol;
  }

  highlightClue(clueElement) {
    // Remove previous clue highlights
    this.cluesTarget.querySelectorAll("li").forEach((li) => {
      li.classList.remove("highlighted-clue");
    });

    // Highlight the selected clue
    clueElement.classList.add("highlighted-clue");
  }
}
