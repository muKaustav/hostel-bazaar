const mongoose = require('mongoose')

let Product = require('./product')

let cartDB = mongoose.createConnection(process.env.CART_DB_URI, { useNewUrlParser: true, useUnifiedTopology: true })

const SingleOrderItemSchema = mongoose.Schema({
    product: { type: mongoose.Schema.Types.ObjectId, ref: Product, required: true },
    quantity: { type: Number, required: true, default: 1 },
})

const CartSchema = mongoose.Schema({
    orderItems: [SingleOrderItemSchema],
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }
}, { timestamps: true })

module.exports = cartDB.model('Cart', CartSchema)