require('dotenv').config()
const cors = require('cors')
const express = require('express')
const hostelRoutes = require('./routes/hostel')
const collegeRoutes = require('./routes/college')
const categoryRoutes = require('./routes/category')
require('./auth/passport')

const app = express()

app.use(cors())
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

app.get('/', (req, res) => {
    res.json({
        message: 'Welcome to the Hostel-Bazaar Admin Service',
        time: new Date().toLocaleString(),
        ip: req.ip
    })
})

app.use('/hostel', hostelRoutes)
app.use('/college', collegeRoutes)
app.use('/category', categoryRoutes)

app.get('*', (req, res) => {
    res.redirect('/')
})

PORT = process.env.PORT || 5005

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}.`)
})