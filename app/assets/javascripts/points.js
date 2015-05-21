function pointsNew(geocode_information) {
    
    // Create an new marker  
    pointsNewMarker = new google.maps.Marker({
        position: new google.maps.LatLng(geocode_information.latitude,geocode_information.longitude), 
        map: Gmaps.map.serviceObject
    });
    
    // Invoke rails app to get the create form
    $.ajax({
        url: '/points/new?' + jQuery.param({point:geocode_information}) + '#chunked=true',
        type: 'GET',
        async: true,
        success: function(html) { 
            
            // Add on close behaviour to clear this marker
            var createFormOpen = function() {
                
                // Open new form                    
                openInfowindow(html, pointsNewMarker);
                
                // Add close infowindow behaviour
                google.maps.event.addListener(Gmaps.map.visibleInfoWindow,'closeclick', function(){
                   clearMarker(pointsNewMarker);
                });   
            }
            
            // Invoke now
            createFormOpen();
            
            // Clicking "again" on the new marker will reproduce behaviour 
            google.maps.event.addListener(pointsNewMarker, "click", function() {
                createFormOpen();
            });
        }
    });
}


/**
 * Open one infowindow at a time 
 */
function openInfowindow(html, marker)  {
    
    // Close previous infowindow if exists
    closeInfowindow();
    
    // Set the content and open
    Gmaps.map.visibleInfoWindow = new google.maps.InfoWindow({content: html});
    Gmaps.map.visibleInfoWindow.open(Gmaps.map.serviceObject, marker);
}

/**
 * Close the infowindow
 */
function closeInfowindow() {
    if (Gmaps.map.visibleInfoWindow) 
        Gmaps.map.visibleInfoWindow.close();
}    

/**
 * Dummy clear marker
 */
function clearMarker(marker) {
    try {
        marker.setMap(null); 
    }
    catch (err){
    }
}

/**
 * Clear marker, including markers array
 */
function clearMarkerById(id) {
    
    // Search and destroy
    clearMarker(findById(id));
    
    // Remove from markers array
    Gmaps.map.markers = Gmaps.map.markers.filter(function(obj) { 
        return obj.id != id
    });   
}

/**
 * Locate the marker in the markers array by id, 
 * then return corresponding serviceObject
 */
function findById(id) {
    var markers_search_results = Gmaps.map.markers.filter(function(obj) { 
        return obj.id == id;
    });
    
    if (markers_search_results[0]) {
        if (markers_search_results[0].serviceObject)
            return markers_search_results[0].serviceObject;
    }
}

/**
 * Geocode with callback invocation
 */
function geocodePoint(latlng, map_id, callback) {

  var latitude = latlng.lat();
  var longitude = latlng.lng();
  
  // Export data by callback on success
  callback({
      latitude: latitude,
      longitude: longitude,
      map_id: map_id
  }); 
}      

function select(buttonId) {
  document.getElementById("hand_b").className="unselected";
  document.getElementById("placemark_b").className="unselected";
  document.getElementById(buttonId).className="selected";
}


function addFeatureEntry(name, color) {
  currentRow_ = document.createElement("tr");
  var colorCell = document.createElement("td");
  currentRow_.appendChild(colorCell);
  colorCell.style.backgroundColor = color;
  colorCell.style.width = "1em";
  var nameCell = document.createElement("td");
  currentRow_.appendChild(nameCell);
  nameCell.innerHTML = name;
  var descriptionCell = document.createElement("td");
  currentRow_.appendChild(descriptionCell);
  featureTable_.appendChild(currentRow_);
  return {desc: descriptionCell, color: colorCell};
}