<template>
<div>
    <div>
        <h4>{{message}}</h4>
    </div>
  <div class="form-group">
    <label class="control-label col-sm-3" for="destination_address">destination address:</label>
    <div class="col-sm-9">
      <input type="text" class="form-control" id="destination_address" v-model="destination_address">
    </div>
  </div>
  <div class="form-group">
    <div class="col-sm-offset-3 col-sm-9">
      <button class="btn btn-default" v-on:click="submitBookingRequest">Search Parking Place</button>
    </div>
  </div>
  <!-- <div><textarea class="col-sm-12" style="background-color:#f4f7ff" rows="4" v-model="messages"></textarea></div> -->
  <div id="map" style="width:100%;height:400px"></div>
</div>
</template>

<script>
import axios from "axios";
import auth from "./auth";

export default {
    data: function() {
        return {
            destination_address: "",
            message: "",
            places: [],
            roads: [],
            centerLocation: null
        }
    },
    methods: {
        submitBookingRequest: function() {
            axios.post("/api/bookings",
                {destination_address: this.destination_address},
                {headers: auth.getAuthHeader()})
                .then(response => {
                    this.messages = response.data.msg;
                    this.places = response.data.places;
                    this.roads = response.data.roads;
                    this.centerLocation = response.data.center;
                    this.addParkingPlacesInMap(this.places, this.roads, this.centerLocation)
                }).catch(error => {
                    console.log(error);
                    this.places = []
                    this.roads = []
                    this.message = "couldn't get parking places"
                    this.centerLocation = {lat: 58.382810, lng: 26.734172}
                    this.addParkingPlacesInMap(this.places, this.roads, this.centerLocation)
                });
        },

        addParkingPlacesInMap: function(places, roads, centerLocation){
            var centerLoc = this.centerLocation;
            var dirService = new google.maps.DirectionsService();
            var mapOptions = {
                zoom: 15, 
                center: centerLoc,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            };
            var map = new google.maps.Map(document.getElementById("map"), mapOptions);
            new google.maps.Marker({position: centerLoc, map: map, title: 'Destination'});
            this.places.forEach(place => {
                var loc = {lat: place.startLat, lng: place.startLng}
                new google.maps.Marker({position: loc, map: map, title: "price in hour " + place.pricePerHour+ "euro/Hour" 
                                                                        +"\n"+ "real time price " + place.pricePerMin+ "euro/5 Min"});
            })
            this.roads.forEach(road => {
                var origin = road.startLat + ", " + road.startLng
                var destination = road.endLat + ", " + road.endLng
                var request = {
                    origin: origin,
                    destination: destination,
                    travelMode: google.maps.TravelMode.DRIVING
                };
                dirService.route(request, function(result, status) {
                    if (status == google.maps.DirectionsStatus.OK) {
                        var dirRenderer = new google.maps.DirectionsRenderer({suppressMarkers: true});
                        dirRenderer.setMap(map);
                        dirRenderer.setDirections(result);
                    }
                });
            })
        }
    },
    mounted: function() {
        if (auth.socket) {
            var channel = auth.getChannel("customer:");
            channel.join()
                .receive("ok", resp => { console.log("Joined successfully", resp) })
                .receive("error", resp => { console.log("Unable to join", resp) });

            channel.on("requests", payload => {
                this.messages += "\n" + payload.msg;
            });
        }
        var loc
        navigator.geolocation.getCurrentPosition(position => {
            loc = {lat: position.coords.latitude, lng: position.coords.longitude};
            this.geocoder = new google.maps.Geocoder;
            this.geocoder.geocode({location: loc}, (results, status) => {
                if (status === "OK" && results[0])
                console.log(results[0]);
                console.log(loc)
                this.destination_address = results[0].formatted_address;
            });
        });
        
        var mapOptions = {
                zoom: 14, 
                center: loc,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            };
        var map = new google.maps.Map(document.getElementById("map"), mapOptions);
        
        // init directions service
        var dirService = new google.maps.DirectionsService();
        


        // highlight a street
        var request = {
        origin: "58.382530, 26.723936",
        destination: "58.381962, 26.720085",
        travelMode: google.maps.TravelMode.DRIVING
        //waypoints: [{location:"48.12449,11.5536"}, {location:"48.12515,11.5569"}],
        };
        dirService.route(request, function(result, status) {
        if (status == google.maps.DirectionsStatus.OK) {
            var dirRenderer = new google.maps.DirectionsRenderer({suppressMarkers: true});
            dirRenderer.setMap(map);
            dirRenderer.setDirections(result);
        }
        });

        var request = {
        origin: "58.382548, 26.723975",
        destination: "58.384388, 26.723241",
        travelMode: google.maps.TravelMode.DRIVING
        //waypoints: [{location:"48.12449,11.5536"}, {location:"48.12515,11.5569"}],
        };
        dirService.route(request, function(result, status) {
        if (status == google.maps.DirectionsStatus.OK) {
            var dirRenderer = new google.maps.DirectionsRenderer({suppressMarkers: true});
            dirRenderer.setMap(map);
            dirRenderer.setDirections(result);
        }
        });

        var request = {
        origin: "58.382810, 26.734172",
        destination: "58.384231, 26.739822",
        travelMode: google.maps.TravelMode.DRIVING
        //waypoints: [{location:"48.12449,11.5536"}, {location:"48.12515,11.5569"}],
        };
        dirService.route(request, function(result, status) {
        if (status == google.maps.DirectionsStatus.OK) {
            var dirRenderer = new google.maps.DirectionsRenderer({suppressMarkers: true});
            dirRenderer.setMap(map);
            dirRenderer.setDirections(result);
        }
        });
        new google.maps.Marker({position: this.loc, map: this.map, title: "Current Location"});

        // var directionDisplay;
        // var directionsService = new google.maps.DirectionsService();
        // var map;

        // var start = new google.maps.LatLng(58.382530, 26.723936);
        // var myOptions = {
        // zoom:14,
        // mapTypeId: google.maps.MapTypeId.ROADMAP,
        // center: start
        // }
        // map = new google.maps.Map(document.getElementById("map"), myOptions);

        // function renderDirections(result) { 
        //     var directionsRenderer = new google.maps.DirectionsRenderer(); 
        //     directionsRenderer.setMap(map); 
        //     directionsRenderer.setDirections(result); 
        // }     

        // function requestDirections(start, end) { 
        // directionsService.route({ 
        //     origin: start, 
        //     destination: end, 
        //     travelMode: google.maps.DirectionsTravelMode.DRIVING 
        // }, function(result) { 
        //     renderDirections(result); 
        // }); 
        // } 

        // requestDirections('(58.382530, 26.723936)', '(58.381962, 26.720085)'); 
        // requestDirections('(58.382548, 26.723975)', '(58.384388, 26.723241)');  
 

    }
}
</script>