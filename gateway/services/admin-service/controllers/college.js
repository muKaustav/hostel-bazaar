const CollegeModel = require('../models/college')

let getColleges = (req, res) => {
    CollegeModel.find({})
        .exec((err, colleges) => {
            if (err) {
                res.send(err)
            } else {
                res.send(colleges)
            }
        })
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