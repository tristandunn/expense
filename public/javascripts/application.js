window.onload = function() {
  var item = document.getElementById('expense_item');

  if (item) {
    item.value   = 'Example: 5.45 on Subway for lunch';
    item.onfocus = function() {
      this.value   = '';
      this.onfocus = null;
    };
  }

  var query = document.getElementById('search_query');

  if (query) {
    query.value   = 'Search your expenses.';
    query.onfocus = function() {
      this.value   = '';
      this.onfocus = null;
    };
  }
};