require('dotenv').config()
const cors = require('cors')
const express = require('express')
const cartRoute = require('./routes/cart')
const savedRoute = require('./routes/saved')
const userRoute = require('./routes/user')
require('./database/db').connect()
require('./auth/passport')

const app = express()

app.use(cors())
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

app.use('/order/cart', cartRoute)
app.use('/order/saved', savedRoute)
app.use('/order/user', userRoute)

PORT = process.env.PORT || 5004

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}.`)
})