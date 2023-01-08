const OrderModel = require('../models/order')

let getOrder = (req, res) => {
    userId = req.user._id
    userRole = req.user.role
    orderId = req.params.orderId

    try {
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
                } else if (order.length === 0) {
                    return res.status(404).send('Not Found')
                } else if (userRole === 'ADMIN') {
                    return res.status(200).send(order)
                } else if (order.userId !== userId) {
                    return res.status(401).send('Unauthorized')
                }

                return res.status(200).send(order)
            })
    } catch {
        return res.status(500).send('Internal Server Error')
    }
}

let getOrders = (req, res) => {
    userId = req.user._id

    try {
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
                    return res.status(404).send('Not Found')
                }

                return res.status(200).send(orders)
            })
    } catch {
        return res.status(500).send('Internal Server Error')
    }
}

let getAllOrders = (req, res) => {
    userRole = req.user.role
    console.log(userRole)

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