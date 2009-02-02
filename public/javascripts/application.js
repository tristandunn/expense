window.onload = function() {
  var item = document.getElementById('expense_item');

  if (item) {
    item.value   = 'Example: 5.45 on Subway for lunch';
    item.onfocus = function() {
      this.value   = '';
      this.onfocus = null;
    };
  }
};