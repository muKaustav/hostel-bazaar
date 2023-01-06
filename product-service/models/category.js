const mongoose = require('mongoose')

const CategorySchema = mongoose.Schema({
    name: { type: String, required: true },
    description: { type: String, required: true },
    image: { type: String, required: true }
}, { timestamps: true })

module.exports = mongoose.model('Category', CategorySchema)