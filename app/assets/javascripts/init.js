//Estamos creando un namespace para nosotros, init inicializará todo nuestro js
if (window.f5App === undefined){
  window.f5App = {};
}

f5App.init = function() {
  console.log("f5App ONLINE!");
};

$(document).on("ready",function(){
  f5App.init();
});