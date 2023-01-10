const CartModel = require('../models/cart')
const ProductModel = require('../models/product')

let getCarts = (req, res) => {
    CartModel.find({})
        .populate('orderItems.product')
        .exec((err, cart) => {
            if (err) {
                res.send(err)
            } else {
                res.send(cart)
            }
        })
}

let addCart = (req, res) => {
    let cart = new CartModel(req.body)

    cart.save((err, cart) => {
        if (err) {
            res.send(err)
        } else {
            res.send(cart)
        }
    })
}

let addItemToCart = (req, res) => {
    userId = req.user._id

    CartModel.findOneAndUpdate(
        { userId: userId },
        { $push: { orderItems: req.body.orderItems } },
        { new: true })
        .populate('orderItems.product')
        .exec((err, cart) => {
            if (err) {
                res.send(err)
            } else {
                res.send(cart)
            }
        })
}

let deleteItemFromCart = (req, res) => {
    userId = req.user._id

    CartModel.findOneAndUpdate(
        { userId: userId },
        { $pull: { orderItems: { product: req.body.orderItemId } } },
        { new: true, multi: true })
        .populate('orderItems.product')
        .exec((err, cart) => {
            if (err) {
                res.send(err)
            } else {
                res.send(cart)
            }
        })
}

let updateQuantity = async (req, res) => {
    userId = req.user._id

    let cart = await CartModel.findOne({ userId: userId })

    let orderItem = cart.orderItems.find(item => item.product == req.body.orderItemId)

    if (orderItem) {
        let product = await ProductModel.findById(req.body.orderItemId)

        if (product) {
            if (req.body.quantity > product.quantity) {
                res.status(400).send({
                    success: false,
                    message: 'Quantity is not available'
                })
            } else {
                orderItem.quantity = req.body.quantity

                cart.save((err, cart) => {
                    if (err) {
                        res.status(500).send({
                            success: false,
                            message: err.message || "Some error occurred while updating the cart."
                        })
                    } else {
                        res.send(cart)
                    }
                })
            }
        }
    } else {
        res.status(404).send({
            success: false,
            message: 'Order item not found'
        })
    }
}

let incrementQuantity = async (req, res) => {
    userId = req.user._id

    let cart = await CartModel.findOne({ userId: userId })

    let orderItem = cart.orderItems.find(item => item.product == req.body.orderItemId)

    if (orderItem) {
        let product = await ProductModel.findById(req.body.orderItemId)

        if (product) {
            if (orderItem.quantity + 1 > product.quantity) {
                res.status(400).send({
                    success: false,
                    message: 'Quantity is not available'
                })
            } else {
                orderItem.quantity += 1

                cart.save((err, cart) => {
                    if (err) {
                        res.status(500).send({
                            success: false,
                            message: err.message || "Some error occurred while updating the cart."
                        })
                    } else {
                        res.send(cart)
                    }
                })
            }
        }
    } else {
        res.status(404).send({
            success: false,
            message: 'Order item not found'
        })
    }
}

let decrementQuantity = async (req, res) => {
    userId = req.user._id

    let cart = await CartModel.findOne({ userId: userId })

    let orderItem = cart.orderItems.find(item => item.product == req.body.orderItemId)

    if (orderItem) {
        let product = await ProductModel.findById(req.body.orderItemId)

        if (product) {
            if (orderItem.quantity - 1 < 1) {
                res.status(400).send({
                    success: false,
                    message: 'Quantity is not available'
                })
            } else {
                orderItem.quantity -= 1

                cart.save((err, cart) => {
                    if (err) {
                        res.status(500).send({
                            success: false,
                            message: err.message || "Some error occurred while updating the cart."
                        })
                    } else {
                        res.send(cart)
                    }
                })
            }
        }
    } else {
        res.status(404).send({
            success: false,
            message: 'Order item not found'
        })
    }
}

module.exports = { getCarts, addCart, addItemToCart, deleteItemFromCart, updateQuantity, incrementQuantity, decrementQuantity }