/**
 * COMMON JAVASCRIPT FUNCTIONS
 * by webmaster@subimage.com
 *
 */

/**
 * Other event handlers use this to set up basic
 * event objects...
 */
function getEventSource(e) {
	/* Cookie-cutter code to find the source of the event */
	if (typeof e == 'undefined') {
		var e = window.event;
	}
	var source;
	if (typeof e.target != 'undefined') {
		source = e.target;
	} else if (typeof e.srcElement != 'undefined') {
		source = e.srcElement;
	} else {
		return false;
	}
	return source;
	/* End cookie-cutter code */
}

/**
 * X-browser event handler attachment
 *
 * @argument obj - the object to attach event to
 * @argument evType - name of the event - DONT ADD "on", pass only "mouseover", etc
 * @argument fn - function to call
 */
function addEvent(obj, evType, fn){
	if (obj == null) return false;

	if (obj.addEventListener){
		obj.addEventListener(evType, fn, false);
		return true;
	} else if (obj.attachEvent){
		var r = obj.attachEvent("on"+evType, fn);
		return r;
	} else {
		return false;
	}
}
function removeEvent(obj, evType, fn, useCapture){
  if (obj.removeEventListener){
    obj.removeEventListener(evType, fn, useCapture);
    return true;
  } else if (obj.detachEvent){
    var r = obj.detachEvent("on"+evType, fn);
    return r;
  } else {
    alert("Handler could not be removed");
  }
}

/**
 * Code below taken from - http://www.evolt.org/article/document_body_doctype_switching_and_more/17/30655/
 *
 * Modified 4/22/04 to work with Opera/Moz (by webmaster at subimage dot com)
 *
 * Gets the full width/height because it's different for most browsers.
 */
function getViewportHeight() {
	if (document.compatMode=='CSS1Compat') return document.documentElement.clientHeight;
	if (document.body) return document.body.clientHeight; 
	if (window.innerHeight!=window.undefined) return window.innerHeight;
	return window.undefined; 
}
function getViewportWidth() {
	var offset = 17;
	var width = null;
	if (document.compatMode=='CSS1Compat') return document.documentElement.clientWidth; 
	if (document.body) return document.body.clientWidth; 
	if (window.innerWidth!=window.undefined) return window.innerWidth; 
}

/**
 * Prettifies our tables applying the proper CSS class after a DOM modification 
 */
function stripedTable() {
	if (document.getElementById && document.getElementsByTagName) {  
		var allTables = document.getElementsByTagName('table');
		if (!allTables) { return; }

		for (var i = 0; i < allTables.length; i++) {
			if (allTables[i].className.match(/[\w\s ]*list[\w\s ]*/)) {
				var trs = allTables[i].getElementsByTagName("tr");
				for (var j = 0; j < trs.length; j++) {
					if (j % 2 == 0) {
						trs[j].className = "even";
					} else {
						trs[j].className = "odd";
					}
				}
			}
		}
	}
}

/**
 * Called from the modal window usually.
 *
 * Refreshes the content in the main window.
 */
function returnRefresh() {
	window.location.reload(true);
}

/**
 * Shows sub tab of content pane passed in.
 * Hides the rest.
 */
function showSubTab(pane_id, tab_link) {
	// Loop through content panes and show the right one
	for (var i=0; i<gPanes.length; i++) {
		if (pane_id == gPanes[i]) {
			Element.show(gPanes[i]);
		} else {
			Element.hide(gPanes[i]);
		}
	}
	// Loop through tabs and assign the right style
	var tabs = $('sub_tabs');
	var active_tab = tab_link.parentNode;
	for (var i=0; i<tabs.childNodes.length; i++) {
		if (active_tab == tabs.childNodes[i]) {
			tabs.childNodes[i].className = "active";
		} else {
			tabs.childNodes[i].className = "";
		}
	}
}
