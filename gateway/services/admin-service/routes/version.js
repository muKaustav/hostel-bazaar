const express = require('express')

const router = express.Router()

router.get('/', (req, res) => {
    res.json({
        message: 'Welcome to the Hostel-Bazaar Admin Service',
        time: new Date().toLocaleString(),
        ip: req.ip
    })
})

router.get('/current', (req, res) => {
    res.json({
        version: '1.0.0+5'
    })
})

router.get('*', (req, res) => {
    res.redirect('/admin')
})

module.exports = router