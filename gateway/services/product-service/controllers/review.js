let ReviewModel = require('../models/review')

let getReviews = async (req, res) => {
    let reviews = await ReviewModel.find({ productId: req.params.productId })
    res.json(reviews)
}

let getReview = async (req, res) => { 
    let review = await ReviewModel.findById(req.body.reviewId)
    res.json(review)
}

let addReview = async (req, res) => { 
    let review = await ReviewModel.create(req.body)
    res.json(review)
}

let updateReview = async (req, res) => { 
    let review = await ReviewModel.findByIdAndUpdate(req.body.reviewId, req.body, { new: true })
    res.json(review)
}

let deleteReview = async (req, res) => { 
    ReviewModel.deleteOne({ _id: req.body.reviewId }, (err) => { 
        if (err) {
            res.send(err)
        }

        res.json({ message: 'Review deleted successfully' })
    })
}

module.exports = { getReviews, getReview, addReview, updateReview, deleteReview }