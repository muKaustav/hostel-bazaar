const ProductModel = require('../models/product')
const CategoryModel = require('../models/category')
let amqp = require('amqplib')
let channel

let connect = async () => {
    let amqpServer = await amqp.connect(process.env.RABBITMQ_URI)
    channel = await amqpServer.createChannel()

    await channel.assertQueue('PRODUCT', { durable: true })
}

connect()

let getProducts = async (req, res) => {
    hostel = req.user.hostel

    ProductModel.find({ hostel: hostel })
        .populate('hostel category sellerId')
        .exec((err, products) => {
            if (err) {
                res.send(err)
            } else {
                res.send(products)
            }
        })
}

let getProductsByCategory = async (req, res) => {
    hostel = req.user.hostel
    category = req.params.category

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
                        res.send(products)
                    }
                })
        }
    })
}

let addProduct = async (req, res) => {
    let product = new ProductModel(req.body)

    product.save((err, product) => {
        if (err) {
            res.send(err)
        } else {
            res.send(product)
        }
    })
}

let buy = async (req, res) => {
    let products = req.body.products
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

    res.send({ status: "pending", message: "Order successfully placed." })
}

module.exports = { getProducts, getProductsByCategory, addProduct, buy }