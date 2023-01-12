const CategoryModel = require('../models/category')
const redis = require('redis')

let redisClient = redis.createClient({
    legacyMode: true,
    socket: {
        port: process.env.REDIS_PORT,
        host: process.env.REDIS_HOST
    }
})

redisClient.connect().catch(console.error)

let getCategories = (req, res) => {
    let cacheKey = `categories`

    try {
        redisClient.get(cacheKey, async (err, categories) => {
            if (err) {
                res.status(500).send(err)
            } else if (categories) { // Cache hit
                res.send(JSON.parse(categories))
            } else { // Cache miss
                CategoryModel.find({})
                    .exec((err, categories) => {
                        if (err) {
                            res.send(err)
                        } else {
                            redisClient.setEx(cacheKey, 60, JSON.stringify(categories))
                            res.send(categories)
                        }
                    })
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