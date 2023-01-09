const mongoose = require('mongoose')

let collegeDB = mongoose.createConnection(process.env.COLLEGE_DB_URI, { useNewUrlParser: true, useUnifiedTopology: true })

const CollegeSchema = new mongoose.Schema({
    name: { type: String, required: true },
    address: { type: String, required: true },
    phoneNumbers: [{ name: { type: String, required: true }, number: { type: String, required: true } }],
    description: { type: String, required: true },
    image: { type: String, required: true },
}, { timestamps: true })

module.exports = collegeDB.model('College', CollegeSchema)