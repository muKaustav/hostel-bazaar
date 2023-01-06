let amqp = require('amqplib')
let OrderModel = require('../models/order')
let channel

let connect = async () => {
    let amqpServer = await amqp.connect(process.env.RABBITMQ_URI)
    channel = await amqpServer.createChannel()

    await channel.assertQueue('ORDER', { durable: true })
}

connect().then(() => {
    channel.consume('ORDER', (data) => {
        const { products, user } = JSON.parse(data.content.toString())

        let amount = 0

        console.log("Products: ", products)

        products.forEach((product) => {
            amount += product.price * product.quantity
        })

        let newOrder = new OrderModel({
            items: products,
            amount: amount,
            userId: user._id,
            status: 'pending'
        })

        newOrder.save()

        console.log("New Order: ", newOrder)

        channel.ack(data)

        channel.sendToQueue('PRODUCT', Buffer.from(JSON.stringify({ newOrder })))
    }, { noAck: false })
})

module.exports = { connect }