import consumer from "channels/consumer"

consumer.subscriptions.create({channel: "CartsChannel"}, {
  connected() {
    console.log("Connected to CartsChannel");
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
 
    console.log('Received data:', data);

    if (data["text"] === 'product updated') {
      const curr_cart = document.querySelector('div[id^=cart_]');
      if (curr_cart !== null) {
        console.log(`Element ${curr_cart.id} found`);
        this.perform("update_cart", { cart_id: curr_cart.id })
        console.log('Cart Updated');
      }
    }
   
    // Called when there's incoming data on the websocket for this channel
  }
});

