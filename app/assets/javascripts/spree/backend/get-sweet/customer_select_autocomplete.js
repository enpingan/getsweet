$.fn.customerAutocomplete = function (options) {
  'use strict';

  // Default options
  options = options || {};
  var multiple = false;

  this.select2({
    minimumInputLength: 1,
    multiple: multiple,
    initSelection: function (element, callback) {
      $.get(Spree.routes.customer_search, {
        ids: element.val().split(','),
        token: Spree.api_key
      }, function (data) {
        callback(multiple ? data.customers : data.customers[0]);
      });
    },
    ajax: {
      url: Spree.routes.customer_search,
      datatype: 'json',
      data: function (term, page) {
        return {
          q: {
            name_cont: term,
            email_cont: term
          },
          m: 'OR',
          token: Spree.api_key
        };
      },
      results: function (data, page) {
        var customers = data.customers ? data.customers : [];
        return {
          results: customers
        };
      }
    },
    formatResult: function (customer) {
      return customer.name;
    },
    formatSelection: function (customer) {
      return customer.name;
    }
  });
};

$(document).ready(function () {
  $('.customer_picker').customerAutocomplete();
});
