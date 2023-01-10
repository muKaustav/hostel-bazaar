require('dotenv').config()
const cors = require('cors')
const express = require('express')
const orderRoute = require('./routes/order')
require('./database/db').connect()
require('./rabbitmq/consumer').connect()
require('./auth/passport')

const app = express()

app.use(cors())
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

app.use('/order', orderRoute)

PORT = process.env.PORT || 5003

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}.`)
})