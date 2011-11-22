if (!window.navigator.standalone) {
  window.addEventListener('load', function() {
    setTimeout(function() {
      window.scrollTo(0, 1);
    }, 100);
  });
}
