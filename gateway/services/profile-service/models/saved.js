const mongoose = require('mongoose')

let Product = require('./product')

const SingleSavedItemSchema = mongoose.Schema({
    product: { type: mongoose.Schema.Types.ObjectId, ref: Product, required: true }
})

const SavedSchema = mongoose.Schema({
    userId: { type: mongoose.Schema.ObjectId, ref: 'User', required: true },
    items: [{ product: { type: mongoose.Schema.Types.ObjectId, ref: Product, required: true } }]
}, { timestamps: true })

module.exports = mongoose.model('Saved', SavedSchema)