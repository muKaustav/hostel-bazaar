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

        products.forEach((product) => {
            amount += product.price * product.quantity
        })

        let newOrder = new OrderModel({
            items: products,
            amount: amount,
            userId: user._id,
            status: 'pending'
        })

        let savedOrder = newOrder.save()

        console.log({ 'order': savedOrder })

        channel.ack(data)
        channel.sendToQueue('PRODUCT', Buffer.from(JSON.stringify({ newOrder })))
    })
})

module.exports = { connect }