const express = require('express')
const passport = require('passport')
const HostelController = require('../controllers/hostel')

const router = express.Router()

router.get('/', (req, res) => {
    res.json({
        message: 'Welcome to the Hostel-Bazaar Admin Service',
        time: new Date().toLocaleString(),
        ip: req.ip
    })
})

router.get('/', HostelController.getHostels)
router.post('/', HostelController.addHostel)

router.get('*', (req, res) => {
    res.redirect('/admin')
})

module.exports = router