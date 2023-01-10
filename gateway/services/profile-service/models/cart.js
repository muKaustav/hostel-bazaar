const mongoose = require('mongoose')

let Product = require('./product')

const SingleOrderItemSchema = mongoose.Schema({
    product: { type: mongoose.Schema.Types.ObjectId, ref: Product, required: true },
    quantity: { type: Number, required: true, default: 1 },
})

const CartSchema = mongoose.Schema({
    orderItems: [SingleOrderItemSchema],
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }
}, { timestamps: true })

module.exports = mongoose.model('Cart', CartSchema)