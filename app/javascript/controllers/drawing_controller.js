import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["canvas", "imageData"]

  connect() {
    this.canvas = new fabric.Canvas(this.canvasTarget)
    this.canvas.isDrawingMode = true
    this.canvas.freeDrawingBrush.width = 5
    this.canvas.freeDrawingBrush.color = "#000000"
    this.loadExistingImage()
  }

  loadExistingImage() {
    const existingImageData = this.imageDataTarget.value
    if (existingImageData) {
      fabric.Image.fromURL(existingImageData, (img) => {
        this.canvas.clear()
        this.canvas.add(img)
        this.canvas.renderAll()
      })
    }
  }

  clear() {
    this.canvas.clear()
  }

  saveImage() {
    this.imageDataTarget.value = this.canvas.toDataURL()
  }
}