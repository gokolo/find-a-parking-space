<template>
<div>
  <div class="form-group">
    <label class="control-label col-sm-3" for="destination_address">destination address:</label>
    <div class="col-sm-9">
      <input type="text" class="form-control" id="destination_address" v-model="destination_address">
    </div>
  </div>
  <div class="form-group">
    <label class="control-label col-sm-3" for="booking_start_time">booking start time:</label>
    <div class="col-sm-9">
      <input type="text" class="form-control" id="booking_start_time" v-model="booking_start_time">
    </div>
  </div>
  <div class="form-group">
    <label class="control-label col-sm-3" for="booking_end_time">booking end time:</label>
    <div class="col-sm-9">
      <input type="text" class="form-control" id="booking_end_time" v-model="booking_end_time">
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
            booking_start_time: "",
            booking_end_time: "",
            messages: ""
        }
    },
    methods: {
        submitBookingRequest: function() {
            axios.post("/api/bookings",
                {destination_address: this.destination_address, booking_start_time: this.booking_start_time, booking_end_time: this.booking_end_time},
                {headers: auth.getAuthHeader()})
                .then(response => {
                    this.messages = response.data.msg;
                }).catch(error => {
                    console.log(error);
                });
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