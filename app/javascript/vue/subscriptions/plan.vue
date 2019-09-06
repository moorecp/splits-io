<template>
  <div class="card">
    <div class="card-header">
      <h4 class="my-0 font-weight-normal">{{name}}</h4>
    </div>
    <div class="card-body">
      <h1 class="card-title pricing-card-title">
        ${{(priceCents || 0) / 100}}
        <small class="text-muted">/ mo</small>
      </h1>
      <ul class="list-unstyled mt-3 mb-4">
        <li v-for='feature in features'>
          {{feature.description}}
          <span v-if='feature.details' v-tippy=true :title='feature.details'>[?]</span>
        </li>
      </ul>
    </div>
    <div class="card-footer">
      <button v-if="!currentUserId" class="btn btn-lg btn-block btn-light disabled" type="button" disabled>
        Sign in to subscribe
      </button>
      <button v-if="currentUserId && !isSubscribed" class="btn btn-lg btn-block btn-light" type="button" @click="subscribe" :disabled='loading'>
        <template v-if='loading'><spinner /></template>
        <template v-else>Subscribe</template>
        <div id="error-message"></div>
      </button>
      <button v-if="currentUserId && isSubscribed && !isCanceled" class="btn btn-lg btn-block btn-outline-light" type='button' @click="cancel" :disabled="loading">
        <template v-if='loading'><spinner /></template>
        <template v-else>Cancel</template>
      </button>
      <button
        v-if="currentUserId && isSubscribed && isCanceled"
        class="btn btn-lg btn-block btn-outline-light disabled"
        type="button"
        v-tippy
        style="cursor: default"
        title="Your subscription has been canceled. It will last until the end of your billing cycle.">
        Canceled
      </button>
    </div>
  </div>
</template>

<script>
import spinner from '../spinner.vue'

export default {
  components: { spinner },
  computed: {
    features: function() {
      switch(this.planType) {
        case 'silver':
          return [
            {description: 'Disable ads'},
            {description: 'Predict when you\'ll PB'},
          ]
        case 'gold':
          return [
            {description: 'Disable ads'},
            {description: 'Predict when you\'ll PB'},
            {
              description: 'Upgrade permalinks to redirectors',
              details: 'Permalink redirectors are links that always redirect to your PB, even when it improves.'
            },
            {description: 'Compare splits with other runners'},
          ]
        default:
          return 'Unknown plan'
      }
    },
    name: function() {
      switch(this.planType) {
        case 'silver':
          return 'Silver'
        case 'gold':
          return 'Gold'
        default:
          return 'Unknown plan'
      }
    },
    priceCents: function() {
      switch(this.planType) {
        case 'silver':
          return 400
        case 'gold':
          return 600
      }
    }
  },
  data: () => ({
    loading: false,
  }),
  methods: {
    cancel: function() {
      this.loading = true

      fetch('/subscriptions', {method: 'DELETE'}).then(() => {
        this.isCanceled = true
        this.loading = false
      })
    },
    subscribe: function() {
      const stripe = Stripe(this.stripePublishableKey)

      this.loading = true
      stripe.redirectToCheckout({
        items: [{plan: this.planId, quantity: 1}],
        successUrl: `${location.origin}/subscriptions/success?session_id={CHECKOUT_SESSION_ID}`,
        cancelUrl: `${location.origin}/subscriptions/cancel`,
        clientReferenceId: this.currentUserId,
        customerEmail: this.currentUserEmail,
      }).then(function (result) {
        if (result.error) {
          var displayError = document.getElementById('error-message')
          displayError.textContent = result.error.message;
        }
      })
    }
  },
  name: 'plan',
  props: ['plan-type', 'plan-id', 'stripe-publishable-key', 'is-subscribed', 'is-canceled', 'current-user-id', 'current-user-email'],
}
</script>
