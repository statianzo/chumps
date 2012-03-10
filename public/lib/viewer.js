(function(api){
  if (typeof window.EventSource == 'undefined') {
    return;
  }

  var es = new EventSource('/view');
  es.onmessage = function(e){
    api.goto(document.getElementById(e.data));
  };
}(window.api));
