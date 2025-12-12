const mongoose = require('mongoose');

const cartSchema = new mongoose.Schema({
  userId: {
    type: String,
    required: true,
    unique: true
  },
  items: [{
    id: String,
    productId: String,
    productName: String,
    productImage: String,
    productPrice: Number,
    quantity: Number,
    toppings: [String],
    createdAt: Date
  }],
  updatedAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Cart', cartSchema);
