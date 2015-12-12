(function() { 
  "use strict";

  var ajax = new f5App.Ajax();

  function getTweets(experts){
    var $expertContainer = $('[data-hook=twitter]')
    $expertContainer.empty();
    var htmlParts = [
      '<dl>',
      '  <dt>Expert:</dt>'
    ]
    htmlParts.push('  <dd>' + experts.expert.name + '</dd>')
    htmlParts.push('</dl>')
    $expertContainer.append(htmlParts.join('\n'));

    var $tweetsContainer = $('[data-hook=tweets]')
    $tweetsContainer.empty();
    var htmlParts = [
      '<dl>',
      '  <dt>Tweets:</dt>'
    ]
    experts.tweets.forEach(function(tt){
      htmlParts.push('<dl>')
      htmlParts.push('  <dd>Id: ' + tt.id + '</dd>')
      htmlParts.push('  <dd>Text: ' + tt.text + '</dd>')
      htmlParts.push('  <dd>Link: ' + tt.link + '</dd>')
      htmlParts.push('  <dd>Rate (1-5): ' + tt.rate + '</dd>')
      htmlParts.push('  <dd>Date: ' + tt.date + '</dd>')

      htmlParts.push('</dl>')
    });

    htmlParts.push('</dl>');
    $tweetsContainer.append(htmlParts.join('\n'));

    $('.input').removeClass("spinner");
    $('.input').addClass("js-axis-hover", "slow");
  } 

  $(document).on('ready',function(){
    
    $('#searcher').on('keypress', function(event){
      if (event.keyCode == 13){ 
        var topic = $('#searcher').val();
        event.preventDefault();
        
        ajax.execute('/f5App/api/tweets/' + topic, getTweets);
        $('.input').addClass("spinner");

      }
    });
  });
})();