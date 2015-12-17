(function() { 
  "use strict";

  var ajax = new f5App.Ajax();
  var topic; 
  
  function getTweets(response){
    var $expertContainer = $('[data-hook=twitter]')
    $expertContainer.empty();
    var context = [{screen_name: response.profile.screen_name,
                     profile_image_url: response.profile.profile_image_url, 
                     expert: response.expert,
                     location: response.profile.location,
                     description: response.profile.description}];
    //$expertContainer.html(HandlebarsTemplates['site/home']());

    
    

   if (response.others.length > 0 ){
      response.others.forEach(function(tt){ 
       context.push( {screen_name: tt.screen_name ,
                     profile_image_url: tt.profile.profile_image_url, 
                     expert: tt.expert,
                     location: tt.profile.location,
                     description: tt.profile.description});
      
      });
    }
      
    $expertContainer.html(HandlebarsTemplates['site/home']({experts: context}));
    
    var $tweetsContainer = $('[data-expert=' + response.profile.screen_name +']');
    
       var tweetParts = ['<div data-hook="tweets" class="col-md-12 tweets">'];
       tweetParts.push('  <div class="row">');
       tweetParts.push('    <div class="span5">');
       tweetParts.push('      <h1 class="most-interesting">Most interesting tweets</h1>');
       tweetParts.push('      <table class="table">');
       tweetParts.push('        <tr>');
       tweetParts.push('          <th class="texto">Text</th>');
       tweetParts.push('        </tr>');
    
    response.tweets.forEach(function(tt){
       tweetParts.push('        <tr>'); 
       tweetParts.push('          <th>' + tt.text + '</th>');
       tweetParts.push('        </tr>');
    });
       tweetParts.push('      </table>');
       tweetParts.push('    </div>');
       tweetParts.push('  </div>');
       tweetParts.push('</div>');

    $tweetsContainer.after(tweetParts.join('\n'));

    // var $tweetsContainer = $('.tweets');//'[data-expert=' + response.profile.screen_name +']');
    // var tweets = []
    // response.tweets.forEach(function(tt){
    //    tweets.push( {text: tt.text});
    // });
    
    // $tweetsContainer.html(HandlebarsTemplates['site/home']({tweets: tweets}));
    // var $others = $('.span5.others');
    // $tweetsContainer.after('<h1>Others you may be interested in:</h1>');

    $('.input').addClass("js-axis-hover", "slow");
    $('#searcher').blur();
    $('#loading').addClass("hidden");
  } 

  function getTweetsOther(response){
    var $expertContainer = $('[data-expert=' + response.screen_name + ']');
    var htmlParts  = ['<div data-hook="tweets" class="col-md-12 tweets">',
                      '  <div class="row">',
                      '    <div class="span5">']
    if (response.tweets.length > 0){
      htmlParts.push('      <h1>More interesting tweets</h1>');
      htmlParts.push('      <table class="table table-striped">');
      htmlParts.push('        <tr>');
      htmlParts.push('          <th>Text</th>');
      htmlParts.push('        </tr>');
      response.tweets.forEach(function(tt){
         htmlParts.push('        <tr>'); 
         htmlParts.push('          <th>' + tt.text + '</th>');
         htmlParts.push('        </tr>');
      });
         htmlParts.push('      </table>');
         htmlParts.push('    </div>');
         htmlParts.push('  </div>');
         htmlParts.push('</div>');
    }else{
      htmlParts.push('<h1>No tengo tweets?!</h1>');
      htmlParts.push('  </div>'),
      htmlParts.push('</div>');
    }
    $expertContainer.append(htmlParts.join('\n'));
    $('#loading').addClass("hidden");
  } 

 function getError(error){
    console.error("Error searching topic: " + error);
    $('#loading').addClass("hidden");
  }

  //Others tweets
  $(document).on('click', '.other', function(event){
    event.preventDefault();
      
    var screen_name = $(event.currentTarget).attr('data-expert');

    ajax.execute('/f5App/api/tweets/' + topic +'/' + screen_name, getTweetsOther, getError);
    $('#loading').removeClass("hidden");
  });
 
  //Searching for topic
  $(document).on('ready',function(){
    $('#searcher').on('keypress', function(event){
      if (event.keyCode == 13){ 
        topic = $('#searcher').val();
        event.preventDefault();
        
        ajax.execute('/f5App/api/tweets/' + topic, getTweets, getError);
        $('#loading').removeClass("hidden");
      }
    });
  });
})();