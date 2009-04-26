window.onload = function() {
  setTimeout(function() {
    window.scrollTo(0, 1);
  }, 100);

  var item = document.getElementById('expense_item');

  if (item) {
    item.value   = 'Example: 5.45 on Subway for lunch';
    item.onfocus = function() {
      this.value   = '';
      this.onfocus = null;
    };
  }
};