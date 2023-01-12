const redis = require('redis')
const OrderModel = require('../models/order')

let redisClient = redis.createClient({
    legacyMode: true,
    socket: {
        port: process.env.REDIS_PORT,
        host: process.env.REDIS_HOST
    }
})

redisClient.connect().catch(console.error)

let getOrder = (req, res) => {
    userId = req.user._id
    userRole = req.user.role
    orderId = req.params.orderId

    let cacheKey = `order_${orderId}`

    try {
        redisClient.get(cacheKey, async (err, order) => {
            if (err) {
                return res.status(500).send(err)
            } else if (order) { // Cache hit
                return res.send(JSON.parse(order))
            } else { // Cache miss
                OrderModel.findOne({ _id: orderId })
                    .populate('userId')
                    .populate({
                        path: 'items.product',
                        populate: {
                            path: 'sellerId'
                        }
                    })
                    .exec((err, order) => {
                        if (err) {
                            return res.status(500).send
                        } else if (!order) {
                            return res.status(404).send('Not Found')
                        } else if (userRole === 'ADMIN') {
                            redisClient.setEx(cacheKey, 60, JSON.stringify(order))
                            return res.status(200).send(order)
                        } else if (order.userId !== userId) {
                            return res.status(401).send('Unauthorized')
                        }

                        redisClient.setEx(cacheKey, 60, JSON.stringify(order))
                        return res.status(200).send(order)
                    }
                    )
            }
        })
    } catch (err) {
        res.status(500).send(err)
    }
}

let getOrders = (req, res) => {
    userId = req.user._id

    let cacheKey = `orders_${userId}`

    try {
        redisClient.get(cacheKey, async (err, orders) => {
            if (err) {
                return res.status(500).send(err)
            } else if (orders) { // Cache hit
                return res.send(JSON.parse(orders))
            } else { // Cache miss
                OrderModel.find({ userId: userId })
                    .populate('userId')
                    .populate({
                        path: 'items.product',
                        populate: {
                            path: 'sellerId'
                        }
                    })
                    .exec((err, orders) => {
                        if (err) {
                            return res.status(500).send
                        } else if (orders.length === 0) {
                            redisClient.setEx(cacheKey, 60, JSON.stringify(orders))
                            return res.status(404).send('Not Found')
                        }

                        return res.status(200).send(orders)
                    })
            }
        })
    } catch (err) {
        res.status(500).send
    }
}

let getAllOrders = (req, res) => {
    userRole = req.user.role

    if (userRole !== 'ADMIN') {
        res.status(401).send('Unauthorized')
    } else {
        try {
            OrderModel.find({})
                .populate('userId')
                .populate({
                    path: 'items.product',
                    populate: {
                        path: 'sellerId'
                    }
                })
                .exec((err, orders) => {
                    if (err) {
                        return res.status(500).send
                    }

                    return res.status(200).send(orders)
                })
        } catch {
            return res.status(500).send('Internal Server Error')
        }
    }
}

let editOrderStatus = (req, res) => {
    let status = req.body.status
    let orderId = req.body.orderId

    if (status === 'completed' || status === 'cancelled') {
        try {
            OrderModel.findOneAndUpdate({ _id: orderId },
                { status: status },
                { new: true })
                .populate('userId')
                .populate({
                    path: 'items.product',
                    populate: {
                        path: 'sellerId'
                    }
                })
                .exec((err, order) => {
                    if (err) {
                        return res.status(500).send
                    }

                    return res.status(200).send(order)
                })
        } catch {
            return res.status(500).send('Internal Server Error')
        }
    }
}

module.exports = { getOrder, getOrders, getAllOrders, editOrderStatus }