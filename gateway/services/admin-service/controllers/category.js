const CategoryModel = require('../models/category')

let getCategories = (req, res) => {
    try {
        CategoryModel.find({})
            .exec((err, categories) => {
                if (err) {
                    res.send(err)
                } else {
                    res.send(categories)
                }
            })
    } catch (err) {
        res.status(500).send(err)
    }
}

let addCategory = (req, res) => {
    let category = new CategoryModel(req.body)

    category.save((err, category) => {
        if (err) {
            res.send(err)
        } else {
            redisClient.del('categories')
            res.send(category)
        }
    })
}

module.exports = { getCategories, addCategory }