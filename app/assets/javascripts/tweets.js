(function() { 
  "use strict";

  var ajax = new f5App.Ajax();

  function getTweets(response){
    var $expertContainer = $('[data-hook=twitter]')
    $expertContainer.empty();
    var htmlParts = ['<div class="row">', 
                      '  <div class="span4">','   <div class="thumbnail">']
    htmlParts.push('  <img src="' + response.profile.profile_image_url + '" style="float: left;margin: 5px;">');
    htmlParts.push('  <h3>' + response.expert + '</h3>');
    htmlParts.push('  <h4>' + response.profile.location + '</h4>');
    htmlParts.push('  <br>');
    htmlParts.push('  <p>' + response.profile.description + '</p>');
    htmlParts.push('    </div>');
    htmlParts.push('  </div>');
    htmlParts.push('</div>');

    htmlParts.push('<div data-hook="tweets" class="col-md-12 tweets">');
    htmlParts.push('<div class="row">');
    htmlParts.push('   <div class="span5">');
    htmlParts.push('  <h1>More interesting tweets</h1>');
    htmlParts.push('    <table class="table table-striped">');
    htmlParts.push('      <tr>');
    htmlParts.push('        <th>Text</th>');
    htmlParts.push('      </tr>');
    
    response.tweets.forEach(function(tt){
      htmlParts.push('<tr>'); 
      htmlParts.push('  <th>' + tt.text + '</th>');
      htmlParts.push('</tr>');
    });

    htmlParts.push('  </table>');
    htmlParts.push('</div>');
    htmlParts.push('</div>');
   
    $expertContainer.append(htmlParts.join('\n'));

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