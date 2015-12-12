(function() { 
  "use strict";

  var ajax = new f5App.Ajax();

  function getTweets(response){
    var $expertContainer = $('[data-hook=twitter]')
    $expertContainer.empty();
    var htmlParts = ['<div class="row">', 
                      '  <div class="span4">','   <div class="thumbnail">']
    htmlParts.push('  <img src="' + response.profile.profile_image_url + '" style="float: left;margin: 5px;">')
    htmlParts.push('  <h3>' + response.expert.name + '</h3>')
    htmlParts.push('  <h4>' + response.profile.location + '</h4>')
    htmlParts.push('  <br>')
    htmlParts.push('  <p>' + response.profile.description + '</p>')
    htmlParts.push('    </div>')
    htmlParts.push('  </div>')
    htmlParts.push('</div>')

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

//     <div class="row">
//   <div class="span4">
//     <div class="thumbnail">
//      <img src="<%= current_user.profile_image_url %>" style="float: left;margin: 5px;">
//       <h3><%= current_user.name %></h3>
//       <h4><%= current_user.location %></h4>
//       <br>
//       <p><%= current_user.description %></p>
//     </div>
//   </div>
// </div>
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