const mongoose = require('mongoose')

let Product = require('./product')

let savedDB = mongoose.createConnection(process.env.SAVED_DB_URI, { useNewUrlParser: true, useUnifiedTopology: true })

const SingleSavedItemSchema = mongoose.Schema({
    product: { type: mongoose.Schema.Types.ObjectId, ref: Product, required: true }
})

const SavedSchema = mongoose.Schema({
    userId: { type: mongoose.Schema.ObjectId, ref: 'User', required: true },
    items: [SingleSavedItemSchema]
}, { timestamps: true })

module.exports = savedDB.model('Saved', SavedSchema)