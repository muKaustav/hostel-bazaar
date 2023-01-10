const mongoose = require('mongoose')
let College = require('./college')

let hostelDB = mongoose.createConnection(process.env.HOSTEL_DB_URI, { useNewUrlParser: true, useUnifiedTopology: true })

const singlePhoneSchema = new mongoose.Schema({
    name: { type: String, required: true },
    number: { type: String, required: true }
})

const HostelSchema = mongoose.Schema({
    name: { type: String, required: true },
    address: { type: String, required: true },
    college: { type: mongoose.Schema.Types.ObjectId, ref: College, required: true },
    phoneNumbers: [singlePhoneSchema],
    description: { type: String, required: true },
    image: { type: String, required: true },
}, { timestamps: true })

module.exports = hostelDB.model('Hostel', HostelSchema)