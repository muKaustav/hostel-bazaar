const mongoose = require('mongoose')
let User = require('./user')

const ReviewSchema = new mongoose.Schema({
    productId: { type: mongoose.Schema.Types.ObjectId, ref: 'Product', required: true },
    userId: { type: mongoose.Schema.Types.ObjectId, ref: User, required: true },
    rating: { type: Number, enum: [1, 2, 3, 4, 5] },
    comment: { type: String, maxlength: [1000, 'Comment can not be more than 1000 characters'] },
    createdAt: { type: Date, default: Date.now },
    updatedAt: { type: Date, default: Date.now }
}, { timestamps: true })

module.exports = mongoose.model('Review', ReviewSchema)