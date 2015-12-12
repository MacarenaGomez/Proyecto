(function(){
  f5App.Ajax = function(){

  };

  f5App.Ajax.prototype.execute = function(uri, callback_function){
    $.ajax({
      url: uri,
      success: function(response){
        callback_function(response);
      },
      fail: function(error){
        console.error("Error searching topic: " + error);
      }
    });
  };

})();