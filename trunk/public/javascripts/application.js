// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
Ajax.Responders.register({
  onCreate: function() {
    if($('busy_indicator') && Ajax.activeRequestCount>0)
      Effect.Appear('busy_indicator',{duration:1,queue:'begin'});
  },
  onComplete: function() {
    if($('busy_indicator') && Ajax.activeRequestCount==0)
      Effect.Fade('busy_indicator',{duration:1,queue:'begin'});
  }
});