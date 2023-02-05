require('dotenv').config()
const cors = require('cors')
const express = require('express')
const hostelRoutes = require('./routes/hostel')
const collegeRoutes = require('./routes/college')
const categoryRoutes = require('./routes/category')
const versionRoutes = require('./routes/version')
require('./auth/passport')

const app = express()

app.use(cors())
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

app.use('/admin/hostel', hostelRoutes)
app.use('/admin/college', collegeRoutes)
app.use('/admin/category', categoryRoutes)
app.use('/admin/version', versionRoutes)

PORT = process.env.PORT || 5005

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}.`)
})