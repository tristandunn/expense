window.onload = function() {
  if (!window.navigator.standalone) {
    setTimeout(function() {
      window.scrollTo(0, 1);
    }, 100);
  }
};
