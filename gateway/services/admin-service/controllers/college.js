const CollegeModel = require('../models/college')

let getColleges = (req, res) => {
    try {
        CollegeModel.find({})
            .exec((err, colleges) => {
                if (err) {
                    res.send(err)
                } else {
                    res.send(colleges)
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
            res.send(college)
        }
    })
}

module.exports = { getColleges, addCollege }