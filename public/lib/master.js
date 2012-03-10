(function(api){
  var _next = api.next,
      _prev = api.prev,
      doNav = function(){ 
        $.post('/navigate/' + $('.step.active')[0].id);
      };

  api.next = function(){
    _next();
    doNav();
  };

  api.prev = function(){
    _prev();
    doNav();
  };
}(window.api));
