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
                            path: 'sellerId',
                            select: 'UPI _id name room_number profile_image hostel college',
                        }
                    })
                    .populate({
                        path: 'userId',
                        select: 'UPI _id name room_number profile_image hostel college',
                    })
                    .exec((err, order) => {
                        if (err) {
                            return res.status(500).send(err)
                        } else if (!order) {
                            return res.status(404).send('Not Found')
                        } else if (userRole === 'ADMIN') {
                            redisClient.setEx(cacheKey, 60, JSON.stringify(order))
                            return res.status(200).send(order)
                        } else if (order.userId !== userId) {
                            return res.status(401).send('Unauthorized')
                        }

                        redisClient.setEx(cacheKey, 10, JSON.stringify(order))
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
                            path: 'sellerId',
                            select: 'UPI _id name room_number profile_image hostel college',
                        }
                    })
                    .populate({
                        path: 'userId',
                        select: 'UPI _id name room_number profile_image hostel college',
                    })
                    .exec((err, orders) => {
                        if (err) {
                            return res.status(500).send(err)
                        } else if (orders.length === 0) {
                            return res.status(404).send('Not Found')
                        }

                        redisClient.setEx(cacheKey, 10, JSON.stringify(orders))
                        return res.status(200).send(orders)
                    })
            }
        })
    } catch (err) {
        res.status(500).send(err)
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
                        path: 'sellerId',
                        select: 'UPI _id name room_number profile_image hostel college',
                    }
                })
                .populate({
                    path: 'userId',
                    select: 'UPI _id name room_number profile_image hostel college',
                })
                .exec((err, orders) => {
                    if (err) {
                        return res.status(500).send(err)
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
                        return res.status(500).send(err)
                    }

                    return res.status(200).send(order)
                })
        } catch {
            return res.status(500).send('Internal Server Error')
        }
    }
}

let lastNOrders = (req, res) => {
    let n = req.params.n

    let cacheKey = `last_n_orders_${n}` + `_hostelId_${req.user.hostelId}`

    try {
        redisClient.get(cacheKey, async (err, products) => {
            if (err) {
                return res.status(500).send(err)
            } else if (products) { // Cache hit
                return res.send(JSON.parse(products))
            } else { // Cache miss
                OrderModel.find({ hostelId: req.user.hostelId })
                    .sort({ createdAt: -1 })
                    .limit(parseInt(n))
                    .populate('items.product')
                    .populate({
                        path: 'items.product',
                        populate: {
                            path: 'sellerId',
                            select: 'UPI _id name room_number profile_image hostel college',
                        }
                    })
                    .populate({
                        path: 'userId',
                        select: 'UPI _id name room_number profile_image hostel college',
                    })
                    .exec((err, products) => {
                        if (err) {
                            return res.status(500).send(err)
                        } else if (products.length === 0) {
                            return res.status(404).send('Not Found')
                        } else {
                            redisClient.setEx(cacheKey, 10, JSON.stringify(products))
                            return res.status(200).send(products)
                        }
                    })
            }
        })
    } catch (err) {
        res.status(500).send(err)
    }
}

let lastNOrdersByUser = (req, res) => {
    let n = req.params.n

    let cacheKey = `last_n_orders_of_user_${n}` + `_userId_${req.user._id}`

    try {
        redisClient.get(cacheKey, async (err, orders) => {
            if (err) {
                return res.status(500).send(err)
            } else if (orders) { // Cache hit
                return res.send(JSON.parse(orders))
            } else { // Cache miss
                OrderModel.find({ userId: req.user._id })
                    .sort({ createdAt: -1 })
                    .limit(parseInt(n))
                    .populate('items.product')
                    .populate({
                        path: 'items.product',
                        populate: {
                            path: 'sellerId',
                            select: 'UPI _id name room_number profile_image hostel college',
                        }
                    })
                    .populate({
                        path: 'userId',
                        select: 'UPI _id name room_number profile_image hostel college',
                    })
                    .exec((err, order) => {
                        if (err) {
                            return res.status(500).send(err)
                        } else if (order.length === 0) {
                            return res.status(404).send('Not Found')
                        } else {
                            console.log(order)
                            redisClient.setEx(cacheKey, 10, JSON.stringify(order))
                            return res.status(200).send(order)
                        }
                    })
            }
        })
    } catch (err) {
        res.status(500).send
    }
}

module.exports = { getOrder, getOrders, getAllOrders, editOrderStatus, lastNOrders, lastNOrdersByUser }