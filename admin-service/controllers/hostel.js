const HostelModel = require('../models/hostel')

let getHostels = (req, res) => {
    HostelModel.find({})
        .exec((err, cart) => {
            if (err) {
                res.send(err)
            } else {
                res.send(cart)
            }
        })
}

let addHostel = (req, res) => {
    let hostel = new HostelModel(req.body)

    hostel.save((err, category) => {
        if (err) {
            res.send(err)
        } else {
            res.send(category)
        }
    })
}

module.exports = { getHostels, addHostel }