require('dotenv').config()
const cors = require('cors')
const express = require('express')
const s3Route = require('./routes')
require('./auth/passport')

const app = express()

app.use(cors())
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

app.use('/s3', s3Route)

PORT = process.env.PORT || 5007

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}.`)
})