<template>
<div>
  <customer v-if="getUserRole() === 'customer'"></customer>
  <driver v-if="getUserRole() === 'taxi-driver'"></driver>
  <div>
          <button class="pull-right"><a href="/login" @click.prevent="logout">Log out!</a></button>
  </div>
</div>  
</template>
<script>
import auth from "./auth";

export default {
    methods: {
        logout: function() {
            auth.logout(this, { headers: auth.getAuthHeader() });
        },
        getUserRole: () => auth.user.role
    }
}
</script>