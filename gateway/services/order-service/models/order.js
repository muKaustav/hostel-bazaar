const mongoose = require('mongoose')
let Product = require('./product')
let User = require('./user')

const SingleOrderItemSchema = mongoose.Schema({
    product: { type: mongoose.Schema.Types.ObjectId, ref: Product, required: true },
    quantity: { type: Number, required: true, default: 1 },
})

const OrderSchema = mongoose.Schema({
    items: [SingleOrderItemSchema],
    amount: { type: Number, required: true },
    userId: { type: mongoose.Schema.Types.ObjectId, ref: User, required: true },
    status: { type: String, enum: ['pending', 'completed', 'cancelled'], default: 'pending', required: true }
}, { timestamps: true })

module.exports = mongoose.model('Order', OrderSchema)