const redis = require('redis')
const ProductModel = require('./services/product-service/models/product')

let redisClient = redis.createClient({
    legacyMode: true,
    socket: {
        port: process.env.REDIS_PORT,
        host: process.env.REDIS_HOST
    }
})

redisClient.connect().catch(console.error)

class Queue {
    constructor() {
        this.items = []
    }

    enqueue = async (element) => {
        if (this.size() < 5) {
            this.items.push(element)
        } else {
            redisClient.del(`product_${element}`)

            while (!this.isEmpty()) {
                await ProductModel.findOneAndUpdate({ _id: this.dequeue() }, { $inc: { visits: 1 } })
                    .catch(err => console.log(err))
            }
        }
    }

    dequeue() {
        return this.items.shift()
    }

    isEmpty() {
        return this.items.length === 0
    }

    size() {
        return this.items.length
    }

    print() {
        console.log(this.items.toString())
    }
}

let jobQueue = new Queue()

module.exports = { jobQueue }