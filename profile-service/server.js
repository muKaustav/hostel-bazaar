require('dotenv').config()
const cors = require('cors')
const express = require('express')
const cartRoute = require('./routes/auth')
const savedRoute = require('./routes/saved')
const userRoute = require('./routes/user')
require('./database/db').connect()
require('./auth/passport')

const app = express()

app.use(cors())
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

app.get('/', (req, res) => {
    res.json({
        message: 'Welcome to the Hostel-Bazaar Profile Service',
        time: new Date().toLocaleString(),
        ip: req.ip
    })
})

app.use('/cart', cartRoute)
app.use('/saved', savedRoute)
app.use('/user', userRoute)

app.get('*', (req, res) => {
    res.redirect('/')
})

PORT = process.env.PORT || 5004

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}.`)
})