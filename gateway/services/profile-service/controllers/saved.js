const SavedController = require('../models/saved')

let getSaved = (req, res) => {
    let userId = req.user._id

    SavedController.find({ userId: userId })
        .populate('items.product')
        .exec((err, saved) => {
            if (err) {
                res.send(err)
            } else {
                res.send(saved)
            }
        })
}

let addSaved = (req, res) => {
    let userId = req.user._id
    let itemId = req.body.itemId

    SavedController.findOne({ userId: userId, 'items._id': itemId })
        .exec((err, saved) => {
            if (err) {
                res.send(err)
            } else {
                if (!saved) {
                    SavedController.findOneAndUpdate({ userId: userId }, { $push: { items: { _id: itemId } } }, { upsert: true, new: true })
                        .populate('items.product')
                        .exec((err, cart) => {
                            if (err) {
                                res.send(err)
                            } else {
                                res.send(cart)
                            }
                        })
                } else {
                    res.send(saved)
                }
            }
        })
}

let removeSaved = (req, res) => {
    let userId = req.user._id
    let itemId = req.body.itemId

    SavedController.findOne({ userId: userId, 'items._id': itemId })
        .exec((err, saved) => {
            if (err) {
                res.send(err)
            } else {
                if (saved) {
                    SavedController.findOneAndUpdate({ userId: userId }, { $pull: { items: { _id: itemId } } }, { upsert: true, new: true })
                        .populate('items.product')
                        .exec((err, wishlist) => {
                            if (err) {
                                res.send(err)
                            } else {
                                res.send(wishlist)
                            }
                        })
                } else {
                    res.send({
                        message: 'Item not found in wishlist.'
                    })
                }
            }
        })
}

module.exports = { getSaved, addSaved, removeSaved }