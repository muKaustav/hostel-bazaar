const HostelModel = require('../models/hostel')

let getHostels = (req, res) => {
    let collegeId = req.query.collegeId

    try {
        HostelModel.find({ college: collegeId })
            .exec((err, hostels) => {
                if (err) {
                    res.send(err)
                } else {
                    res.send(hostels)
                }
            })
    } catch (err) {
        res.status(500).send(err)
    }
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