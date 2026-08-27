// ES module: carica i partial e poi annuncia che sono pronti
async function loadPartials() {
  const slots = document.querySelectorAll('[data-include]');
  for (const el of slots) {
    const url = el.getAttribute('data-include');
    const res = await fetch(url);
    if (!res.ok) throw new Error(`HTTP ${res.status} for ${url}`);
    el.outerHTML = await res.text(); // sostituisce il placeholder con l'header (che apre .app)
  }
  document.dispatchEvent(new Event('partials:loaded'));
}
await loadPartials();
