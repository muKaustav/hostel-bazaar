const mongoose = require('mongoose')

const singlePhoneSchema = new mongoose.Schema({
    name: { type: String, required: true },
    number: { type: String, required: true }
})

const HostelSchema = mongoose.Schema({
    name: { type: String, required: true },
    address: { type: String, required: true },
    phoneNumbers: [singlePhoneSchema],
    description: { type: String, required: true },
    image: { type: String, required: true },
}, { timestamps: true })

module.exports = mongoose.model('Hostel', HostelSchema)