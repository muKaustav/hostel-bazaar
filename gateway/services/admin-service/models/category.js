const mongoose = require('mongoose')

let categoryDB = mongoose.createConnection(process.env.CATEGORY_DB_URI, { useNewUrlParser: true, useUnifiedTopology: true })

const CategorySchema = mongoose.Schema({
    name: { type: String, required: true },
    description: { type: String, required: true },
    image: { type: String, required: true }
}, { timestamps: true })

module.exports = categoryDB.model('Category', CategorySchema)