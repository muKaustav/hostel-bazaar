const CategoryModel = require('../models/category')

let getCategories = (req, res) => {
    CategoryModel.find({})
        .exec((err, cart) => {
            if (err) {
                res.send(err)
            } else {
                res.send(cart)
            }
        })
}

let addCategory = (req, res) => {
    let category = new CategoryModel(req.body)

    category.save((err, category) => {
        if (err) {
            res.send(err)
        } else {
            res.send(category)
        }
    })
}

module.exports = { getCategories, addCategory }