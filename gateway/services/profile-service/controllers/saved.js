const SavedController = require('../models/saved')

let getSaved = (req, res) => {
    SavedController.find({})
        .populate('items.product')
        .exec((err, cart) => {
            if (err) {
                res.send(err)
            } else {
                res.send(cart)
            }
        })
}

let addSaved = (req, res) => {
    let saved = new SavedController(req.body)

    saved.save((err, saved) => {
        if (err) {
            res.send(err)
        } else {
            res.send(saved)
        }
    })
}

module.exports = { getSaved, addSaved }