(function () {
  const slides = Array.from(document.querySelectorAll(".slide"));
  if (!slides.length) return;

  let current = Math.max(0, slides.findIndex((slide) => slide.classList.contains("active")));
  if (current === -1) current = 0;

  const progress = document.createElement("div");
  progress.className = "progress";
  progress.innerHTML = '<div class="progress-bar"></div>';

  const slideNumber = document.createElement("div");
  slideNumber.className = "slide-number";

  document.body.append(progress, slideNumber);

  function fragments(slide) {
    return Array.from(slide.querySelectorAll(".fragment"));
  }

  function updateHash() {
    const id = slides[current].id || `slide-${current + 1}`;
    if (location.hash !== `#${id}`) {
      history.replaceState(null, "", `#${id}`);
    }
  }

  function showSlide(index, revealAll = false) {
    current = Math.min(Math.max(index, 0), slides.length - 1);
    slides.forEach((slide, i) => {
      slide.classList.toggle("active", i === current);
      fragments(slide).forEach((fragment) => {
        fragment.classList.toggle("visible", revealAll && i === current);
      });
    });

    progress.querySelector(".progress-bar").style.width = `${((current + 1) / slides.length) * 100}%`;
    slideNumber.textContent = `${current + 1} / ${slides.length}`;
    updateHash();
  }

  function next() {
    const nextFragment = fragments(slides[current]).find((fragment) => !fragment.classList.contains("visible"));
    if (nextFragment) {
      nextFragment.classList.add("visible");
      return;
    }
    showSlide(current + 1);
  }

  function previous() {
    const visible = fragments(slides[current]).filter((fragment) => fragment.classList.contains("visible"));
    if (visible.length) {
      visible[visible.length - 1].classList.remove("visible");
      return;
    }
    showSlide(current - 1, true);
  }

  const hashIndex = slides.findIndex((slide) => `#${slide.id}` === location.hash);
  showSlide(hashIndex >= 0 ? hashIndex : current);

  document.addEventListener("keydown", (event) => {
    if (["ArrowRight", "ArrowDown", " ", "PageDown"].includes(event.key)) {
      event.preventDefault();
      next();
    } else if (["ArrowLeft", "ArrowUp", "PageUp", "Backspace"].includes(event.key)) {
      event.preventDefault();
      previous();
    } else if (event.key.toLowerCase() === "f" && document.fullscreenEnabled) {
      document.fullscreenElement ? document.exitFullscreen() : document.documentElement.requestFullscreen();
    }
  });

  document.addEventListener("click", (event) => {
    if (event.target.closest("a, button, pre, code")) return;
    next();
  });

  let touchStartX = 0;
  document.addEventListener("touchstart", (event) => {
    touchStartX = event.changedTouches[0].screenX;
  }, { passive: true });

  document.addEventListener("touchend", (event) => {
    const delta = event.changedTouches[0].screenX - touchStartX;
    if (Math.abs(delta) > 45) {
      delta < 0 ? next() : previous();
    }
  }, { passive: true });
})();
