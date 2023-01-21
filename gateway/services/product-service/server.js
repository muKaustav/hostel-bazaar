require('dotenv').config()
const cors = require('cors')
const express = require('express')
const productRoutes = require('./routes/product')
require('./database/db').connect()
require('./auth/passport')

const app = express()

app.use(cors())
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

app.use('/product', productRoutes)

PORT = process.env.PORT || 5002

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}.`)
})