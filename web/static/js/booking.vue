<template>
<div class="container">
  <h2>{{message}}</h2>
  <h2>Booking Information</h2>
  <p>Book place for {{$route.params.intented_stay}} min</p>
  <p v-if="$route.params.hourlyBasedCost !=0">Hourly based cost {{$route.params.hourlyBasedCost}} euro</p>
  <p v-if="$route.params.realTimeBasedCost !=0">real Time based cost {{$route.params.realTimeBasedCost}} euro</p>
  <div v-if="$route.params.hourlyBasedCost !=0" class="form-group">
    <p>Payment Option:</p>
    <div class="radio">
      <label><input type="radio" name="paymentOption" value="PAY_NOW" v-model="paymentOption" checked>Pay Now</label>
    </div>
    <div class="radio">
      <label><input type="radio" name="paymentOption" value="PAY_LATER" v-model="paymentOption">Pay Later</label>
    </div>
  </div>

  <div  v-if="$route.params.hourlyBasedCost !=0" class="form-group">
    <p>Hourly or RealTime?</p>
    <div class="radio">
      <label><input type="radio" name="paymentType" value="HOURLY" v-model="paymentType" checked>Hourly Based</label>
    </div>
    <div class="radio">
      <label><input type="radio" name="paymentType" value="REAL_TIME" v-model="paymentType">Real Time Based</label>
    </div>
  </div>

  <div class="form-group">
    <div class="col-sm-offset-3 col-sm-9">
      <button class="btn btn-default" v-on:click="submitBookingRequest">Book The Place</button>
    </div>
  </div>
</div>
</template>
<script>
import axios from "axios";
import auth from "./auth";
import socket from "./socket";

export default {
  data: function() {
    return {
        paymentOption: "",
        paymentType: "",
        hourlyBasedCost: this.$route.params.hourlyBasedCost,
        realTimeBasedCost: this.$route.params.realTimeBasedCost,
        intented_stay: this.$route.params.intented_stay,
        place_id: this.$route.params.place_id,
        message: null
    }
  },
  methods: {
    submitBookingRequest: function () {
      var paying_status
      var estimated_time = this.$route.params.intented_stay
      var estimated_cost
      if(this.paymentOption == "PAY_LATER"){
        paying_status = "UNPAID"
      }else{
        paying_status = "PAID"
      }

      if(this.paymentType == "REAL_TIME"){
        estimated_cost = this.hourlyBasedCost
      }else{
        estimated_cost = this.realTimeBasedCost
      }
        axios.post("/api/book-place", 
            {
              paying_status: paying_status,
              estimated_time: parseInt(estimated_time),
              estimated_cost: parseFloat(estimated_cost),
              place_id: parseInt(this.place_id)
            }, 
            {headers: auth.getAuthHeader()})
        .then( response => {
            console.log("Received:", response );
            this.message = response.data.message
        }).catch( e => console.log("Oops"));
        
      
    }
  },
  mounted: function() {
    
  }
}
</script>