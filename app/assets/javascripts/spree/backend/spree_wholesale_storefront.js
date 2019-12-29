// Placeholder manifest file.
// the installer will append this file to the app vendored assets here: vendor/assets/javascripts/spree/backend/all.js'
$(function() {
  $('.wholesaler_toggle_button').click(function() {
    $('#create_wholesaler_form').toggleClass("d-none hidden");
    $('#create_wholesaler_button').toggleClass("d-none hidden");
  });
});
