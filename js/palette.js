(function () {
  const KEY = 'palette';

  function init() {
    try {
      const saved = localStorage.getItem(KEY);
      if (saved) {
        const el = document.getElementById(saved);
        if (el && el.type === 'radio') el.checked = true;
      }
    } catch (e) {}

    const inputs = document.querySelectorAll('input[name="palette"]');
    inputs.forEach(inp => {
      inp.addEventListener('change', () => {
        if (inp.checked) {
          try { localStorage.setItem(KEY, inp.id); } catch (e) {}
        }
      });
    });

    try {
      if (!localStorage.getItem(KEY)) {
        const checked = Array.from(inputs).find(i => i.checked);
        if (checked) localStorage.setItem(KEY, checked.id);
      }
    } catch (e) {}
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
  document.addEventListener('partials:loaded', init);
})();
