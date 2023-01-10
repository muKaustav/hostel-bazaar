let amqp = require('amqplib')
let channel

let connect = async () => {
    let amqpServer = await amqp.connect(process.env.RABBITMQ_URI)
    channel = await amqpServer.createChannel()

    await channel.assertQueue('PRODUCT', { durable: true })

    return channel
}

module.exports = { connect }