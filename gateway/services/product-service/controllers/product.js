const redis = require('redis')
const ProductModel = require('../models/product')
const CategoryModel = require('../models/category')
let OrderModel = require('../models/order')
let { jobQueue } = require('../../../jobQueue')
let amqp = require('amqplib')
let channel

let redisClient = redis.createClient({
    legacyMode: true,
    socket: {
        port: process.env.REDIS_PORT,
        host: process.env.REDIS_HOST
    }
})

redisClient.connect().catch(console.error)

let connect = async () => {
    let amqpServer = await amqp.connect(process.env.RABBITMQ_URI)
    channel = await amqpServer.createChannel()

    await channel.assertQueue('PRODUCT', { durable: true })
}

connect()

let getProducts = async (req, res) => {
    hostel = req.user.hostel

    let cacheKey = `products_${hostel}`

    try {
        redisClient.get(cacheKey, async (err, products) => {
            if (err) {
                res.send(err)
            } else if (products) { // Cache hit
                console.log("Cache hit")
                res.send(JSON.parse(products))
            } else { // Cache miss
                console.log("Cache miss")
                ProductModel.find({ hostel: hostel })
                    .populate('hostel category sellerId')
                    .exec((err, products) => {
                        if (err) {
                            res.send(err)
                        } else {
                            redisClient.setEx(cacheKey, 10, JSON.stringify(products))
                            res.send(products)
                        }
                    })
            }
        })
    } catch (err) {
        res.status(500).send(err)
    }
}

let getProductsByCategory = async (req, res) => {
    hostel = req.user.hostel
    category = req.params.category

    let cacheKey = `products_${hostel}_${category}`

    try {
        redisClient.get(cacheKey, async (err, products) => {
            if (err) {
                res.send
            } else if (products) { // Cache hit
                res.send(JSON.parse(products))
            } else { // Cache miss
                CategoryModel.findOne({ name: category }, (err, category) => {
                    if (err) {
                        res.send(err)
                    } else {
                        ProductModel.find({ hostel: hostel, category: category._id })
                            .populate('hostel category sellerId')
                            .exec((err, products) => {
                                if (err) {
                                    res.send(err)
                                } else {
                                    redisClient.setEx(cacheKey, 10, JSON.stringify(products))
                                    res.send(products)
                                }
                            })
                    }
                })
            }
        })
    } catch (err) {
        res.status(500).send(err)
    }
}

let getProduct = async (req, res) => {
    let productId = req.params.productId

    let cacheKey = `product_${productId}`

    try {
        redisClient.get(cacheKey, async (err, product) => {
            if (err) {
                res.send(err)
            } else if (product) { // Cache hit
                jobQueue.enqueue(productId)
                res.send(JSON.parse(product))
            } else { // Cache miss
                ProductModel.findOneAndUpdate
                    ({ _id: productId }, { $inc: { visits: 1 } }, { new: true })
                    .populate('hostel category sellerId')
                    .exec((err, product) => {
                        if (err) {
                            res.send(err)
                        } else {
                            redisClient.setEx(cacheKey, 10, JSON.stringify(product))
                            res.send(product)
                        }
                    })
            }
        })
    } catch (err) {
        res.status(500).send(err)
    }
}

let addProduct = async (req, res) => {
    let product = new ProductModel(req.body)

    product.save((err, product) => {
        if (err) {
            res.send(err)
        } else {
            // Clear cache
            redisClient.keys(`products_${product.hostel}*`, (err, keys) => {
                if (err) {
                    console.log(err)
                } else {
                    keys.forEach((key) => {
                        redisClient.del(key)
                    })
                }
            })

            res.send(product)
        }
    })
}

let search = async (req, res) => {
    let hostel = req.user.hostel
    let query = req.params.query

    let cacheKey = `products_${hostel}_${query}`

    try {
        redisClient.get(cacheKey, async (err, products) => {
            if (err) {
                res.send(err)
            } else if (products) { // Cache hit
                res.send(JSON.parse(products))
            } else { // Cache miss
                ProductModel.aggregate([{
                    "$search": {
                        "autocomplete": {
                            "query": query,
                            "path": "name",
                            "fuzzy": {
                                "maxEdits": 2,
                                "maxExpansions": 100
                            }
                        }
                    }
                }]).exec((err, products) => {
                    if (err) {
                        res.send(err)
                    } else {
                        redisClient.setEx(cacheKey, 10, JSON.stringify(products))
                        res.send(products)
                    }
                })
            }
        })
    } catch (err) {
        res.status(500).send(err)
    }
}

let buy = async (req, res) => {
    let data = JSON.parse(JSON.parse(JSON.stringify(req.rawBody)))
    let products = data.products
    let user = req.user

    for (let i = 0; i < products.length; i++) {
        let product = await ProductModel.findById(products[i].product)
        products[i].price = product.price

        product.quantity -= products[i].quantity
        product.save()
    }

    console.log(products, user)

    channel.sendToQueue('ORDER', Buffer.from(JSON.stringify({ products, user })))

    channel.consume('PRODUCT', (data) => {
        let order = JSON.parse(data.content.toString())

        console.log(order)

        channel.ack(data)
    }, { noAck: false })

    let order = await OrderModel.findOne({ user: user._id })
        .sort({ _id: -1 })
        .limit(1)

    res.send({ status: "pending", message: "Order successfully placed.", order: order })
}

module.exports = { getProducts, getProductsByCategory, getProduct, addProduct, buy, search }