
function fetch_nownext()
{

  new Ajax.Request('/nownext', {
    method:'get',
    requestHeaders: {Accept: 'application/json'},
    onSuccess: function(transport){
      var json = transport.responseText.evalJSON(true);
      $('now-name').update(json.now.name)
      $('now-description').update(json.now.description)
      $('next-name').update(json.next.name)
      $('next-description').update(json.next.description)
    },
    onFailure: function(transport) {
      window.alert( "HTTP request failed: "+transport.status );
    }
  });

}

function change_channel()
{
  var channel = $F('channels')
  new Ajax.Request('/select?'+ encodeURIComponent(channel), {
    method:'get',
    requestHeaders: {Accept: 'application/json'},
    onSuccess: function(transport){
      var json = transport.responseText.evalJSON(true);
      fetch_nownext();
    },
    onFailure: function(transport) {
      window.alert( "Request to change channel failed: "+transport.status );
    }
  });


}