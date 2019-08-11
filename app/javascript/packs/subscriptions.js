/* eslint no-console: 0 */
import Vue from 'vue/dist/vue.esm'

import TurbolinksAdapter from 'vue-turbolinks'
import VueTippy from 'vue-tippy'

import plan from '../vue/subscriptions/plan.vue'

Vue.use(TurbolinksAdapter)
Vue.use(VueTippy)

document.addEventListener('turbolinks:load', () => {
  if (document.getElementById('vue-subscriptions') === null) {
    return
  }

  const app = new Vue({
    el: '#vue-subscriptions',
    components: { plan },
  })
})
