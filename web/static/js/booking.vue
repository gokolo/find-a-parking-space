<template>
<div>
   <h2>hello {{$route.params.intented_stay}}</h2>
   <h2>hello {{$route.params.place_id}}</h2>
</div>
</template>
<script>
import axios from "axios";
import auth from "./auth";
import socket from "./socket";

export default {
  data: function() {
    return {
      
    }
  },
  methods: {
    submitDecision: function (decision) {
      if (this.message) {
        axios.patch("/api/bookings/" +this.message.booking_id, 
            {status: decision.status}, {headers: auth.getAuthHeader()})
        .then( response => {
            console.log("Received:", response );
        }).catch( e => console.log("Oops"));
        
      }
    }
  },
  mounted: function() {
    
  }
}
</script>