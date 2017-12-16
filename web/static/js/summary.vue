<template>

<!-- <style>
#customers {
    font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
    border-collapse: collapse;
    width: 100%;
}

#customers td, #customers th {
    border: 1px solid #ddd;
    padding: 8px;
}

#customers tr:nth-child(even){background-color: #f2f2f2;}

#customers tr:hover {background-color: #ddd;}

#customers th {
    padding-top: 12px;
    padding-bottom: 12px;
    text-align: left;
    background-color: #4CAF50;
    color: white;
}
</style> -->
<div>

<table v-if="bookings.length > 0">
  <tr>
    <th>Booking Start Time</th>
    <th>Booking time</th>
    <th>Estimated Cost</th>
    <th>Payment Status</th>
    <th>Action</th>
  </tr>
  <tr v-repeat= "item in bookings">
    <td>{{item.inserted_at}}</td>
    <td>{{item.estimated_time}}</td>
    <td>{{item.estimated_cost}}</td>
    <td>{{item.paying_status}}</td>
    <span v-if="item.paying_status == 'UNPAID'">Pay</span>
  </tr>
  
</table>

</div>
</template>
<script>
import axios from "axios";
import auth from "./auth";
import socket from "./socket";

export default {
  data: function() {
    return {
        bookings: []
    }
  },
  methods: {
    
  },
  mounted: function() {
    axios.get("/api/bookings/summary",  
        {headers: auth.getAuthHeader()})
    .then( response => {
        console.log("Received:", response );
        this.bookings = response.data
    }).catch( e => console.log("Oops"));
  }
}
</script>