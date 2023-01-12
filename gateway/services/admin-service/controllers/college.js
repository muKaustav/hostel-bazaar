const CollegeModel = require('../models/college')
const redis = require('redis')

let redisClient = redis.createClient({
    legacyMode: true,
    socket: {
        port: process.env.REDIS_PORT,
        host: process.env.REDIS_HOST
    }
})

let getColleges = (req, res) => {
    let cacheKey = `colleges`

    try {
        redisClient.get(cacheKey, async (err, colleges) => {
            if (err) {
                res.send(err)
            } else if (colleges) { // Cache hit
                res.send(JSON.parse(colleges))
            } else { // Cache miss
                CollegeModel.find({})
                    .exec((err, colleges) => {
                        if (err) {
                            res.send(err)
                        } else {
                            redisClient.setEx(cacheKey, 60, JSON.stringify(colleges))
                            res.send(colleges)
                        }
                    })
            }
        })
    } catch (err) {
        res.status(500).send(err)
    }
}

let addCollege = (req, res) => {
    let college = new CollegeModel(req.body)

    college.save((err, college) => {
        if (err) {
            res.send(err)
        } else {
            redisClient.del('colleges')
            res.send(college)
        }
    })
}

module.exports = { getColleges, addCollege }