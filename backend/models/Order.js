const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema({
  orderNumber: {
    type: String,
    required: true,
    unique: true
  },
  userId: {
    type: String,
    required: true
  },
  userEmail: String,
  userName: String,
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
  shippingAddress: {
    street: String,
    city: String,
    state: String,
    zipCode: String,
    country: String
  },
  paymentInfo: {
    method: String,
    transactionId: String,
    status: String,
    paidAt: Date
  },
  subtotal: Number,
  tax: Number,
  shippingCost: Number,
  discount: {
    type: Number,
    default: 0
  },
  total: Number,
  status: {
    type: String,
    enum: ['pending', 'processing', 'shipped', 'delivered', 'cancelled'],
    default: 'pending'
  },
  notes: String,
  tracking: {
    events: [{
      status: String,
      description: String,
      timestamp: Date
    }]
  },
  estimatedDelivery: Date,
  createdAt: {
    type: Date,
    default: Date.now
  },
  updatedAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Order', orderSchema);
