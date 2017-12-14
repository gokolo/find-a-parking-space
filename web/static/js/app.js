import Vue from "vue";
import VueRouter from "vue-router";

import login from "./login";
import customer from "./customer";
import driver from "./driver";
import main from "./main";
import booking from "./booking";

import "phoenix";
import "axios";
import "./socket";
import auth from './auth'

const requireAuth = (to, _from, next) => {
  if (!auth.authenticated()) {
    next({
      path: '/login',
      query: { redirect: to.fullPath }
    });
  } else {
    next();
  }
}

const afterAuth = (_to, from, next) => {
  if (auth.authenticated()) {                     
    next(from.path);
  } else {
    next();
  }
}

Vue.use(VueRouter);

Vue.component("customer", customer);
Vue.component("driver", driver);
Vue.component("booking", booking);

var router = new VueRouter({
    routes: [
        { path: '/login', component: login, beforeEnter: afterAuth },
        { path: '/', component: main, beforeEnter: requireAuth },
        { path: '/booking/:intented_stay/:place_id', component: booking, beforeEnter: requireAuth},
        { path: '*', redirect: '/login' }
    ]
});

new Vue({
    router
}).$mount("#takso-app");