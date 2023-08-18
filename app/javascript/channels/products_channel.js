import consumer from "channels/consumer"

consumer.subscriptions.create("ProductsChannel", {
  connected() {
    console.log("Connected to ProductsChannel");
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    
  }
});
