const HostelModel = require('../models/hostel')

let getHostels = (req, res) => {
    let cacheKey = `hostels`

    try {
        redisClient.get(cacheKey, async (err, hostels) => {
            if (err) {
                res.send(err)
            } else if (hostels) { // Cache hit
                res.send(JSON.parse(hostels))
            } else { // Cache miss
                HostelModel.find({})
                    .exec((err, hostels) => {
                        if (err) {
                            res.send(err)
                        } else {
                            res.send(hostels)
                        }
                    })
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
            redisClient.del('hostels')
            res.send(category)
        }
    })
}

module.exports = { getHostels, addHostel }