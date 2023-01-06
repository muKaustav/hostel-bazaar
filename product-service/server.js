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

app.get('/', (req, res) => {
    res.json({
        message: 'Welcome to the Hostel-Bazaar Product Service',
        time: new Date().toLocaleString(),
        ip: req.ip
    })
})

app.use('/product', productRoutes)

app.get('*', (req, res) => {
    res.redirect('/')
})

PORT = process.env.PORT || 5002

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}.`)
})