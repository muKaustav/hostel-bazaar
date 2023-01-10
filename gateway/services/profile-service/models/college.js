const mongoose = require('mongoose')

const CollegeSchema = new mongoose.Schema({
    name: { type: String, required: true },
    address: { type: String, required: true },
    phoneNumbers: [{ name: { type: String, required: true }, number: { type: String, required: true } }],
    description: { type: String, required: true },
    image: { type: String, required: true },
}, { timestamps: true })

module.exports = mongoose.model('College', CollegeSchema)