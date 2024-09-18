import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["canvas", "imageData"]

  connect() {
    this.canvas = new fabric.Canvas(this.canvasTarget)
    this.canvas.isDrawingMode = true
    this.canvas.freeDrawingBrush.width = 5
    this.canvas.freeDrawingBrush.color = "#000000"
  }

  clear() {
    this.canvas.clear()
  }

  saveImage() {
    this.imageDataTarget.value = this.canvas.toDataURL()
  }
}