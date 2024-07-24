import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["text"]

  connect() {
    if (this.element.dataset.animate === "true") {
      this.animateText();
    }
  }

  animateText() {
    const fullText = this.textTarget.textContent.trim();
    const words = fullText.split(' ');
    this.textTarget.textContent = '';
    let i = 0;

    const interval = setInterval(() => {
      if (i < words.length) {
        this.textTarget.textContent += words[i] + ' ';
        i++;
      } else {
        clearInterval(interval);
      }
    }, 200); 
  }
}
