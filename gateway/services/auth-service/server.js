require('dotenv').config()
const cors = require('cors')
const express = require('express')
const authRoute = require('./routes/auth')
const path = require('path')
require('./database/db').connect()
require('./auth/passport')

const app = express()

app.use(cors())
app.use(express.json())
app.use(express.urlencoded({ extended: true }))
app.use(express.static(path.join(__dirname, 'public')))

app.use('/auth', authRoute)

PORT = process.env.PORT || 5001

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}.`)
})