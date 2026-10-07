// Phone menu
(function () {
  var menu = document.getElementById('mobile-menu');
  var open = document.querySelector('.nav-toggle');
  var close = document.querySelector('.menu-close');
  if (menu && open && close) {
    var set = function (on) {
      menu.classList.toggle('open', on);
      open.setAttribute('aria-expanded', on ? 'true' : 'false');
      document.body.style.overflow = on ? 'hidden' : '';
    };
    open.addEventListener('click', function () { set(true); });
    close.addEventListener('click', function () { set(false); });
    document.addEventListener('keydown', function (e) { if (e.key === 'Escape') set(false); });
  }

  // Questions: one answer open at a time
  var items = document.querySelectorAll('.faq-item');
  var show = function (target) {
    items.forEach(function (it) {
      var on = it === target && it.getAttribute('aria-expanded') !== 'true';
      it.setAttribute('aria-expanded', on ? 'true' : 'false');
      it.querySelector('p').hidden = !on;
      it.querySelector('.faq-icon').textContent = on ? '\u2013' : '+';
    });
  };
  items.forEach(function (it) {
    it.addEventListener('click', function () { show(it); });
    it.addEventListener('keydown', function (e) {
      if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); show(it); }
    });
  });
})();
