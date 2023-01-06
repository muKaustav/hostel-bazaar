const mongoose = require('mongoose')
let Hostel = require('./hostel')
let User = require('./user')

const ProductSchema = new mongoose.Schema({
    name: {
        type: String,
        trim: true,
        required: [true, 'Please provide product name'],
        maxlength: [100, 'Name can not be more than 100 characters'],
    },

    description: {
        type: String,
        required: [true, 'Please provide product description'],
        maxlength: [1000, 'Description can not be more than 1000 characters'],
    },

    price: {
        type: Number,
        required: [true, 'Please provide product price'],
        default: 0,
    },

    image: {
        type: String,
        default: '/uploads/example.jpeg',
    },

    category: { type: mongoose.Schema.Types.ObjectId, ref: 'Category', required: true },

    quantity: {
        type: Number,
        required: [true, 'Please provide product quantity'],
    },

    hostel: { type: mongoose.Schema.Types.ObjectId, ref: Hostel, required: true },

    sellerId: { type: mongoose.Schema.Types.ObjectId, ref: User, required: true },
}, { timestamps: true })

module.exports = mongoose.model('Product', ProductSchema)