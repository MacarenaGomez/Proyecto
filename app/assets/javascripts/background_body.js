$(document).on('ready', function(){
  $('#searcher').on('focus', function() {
    $('body').removeClass('grey_background');
    $('body').addClass('focused');
  }).on('blur', function() {
    $('body').removeClass('focused');
    $('body').addClass('grey_background');
  });
});

