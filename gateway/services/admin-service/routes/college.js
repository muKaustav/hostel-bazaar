const express = require('express')
const passport = require('passport')
const CollegeController = require('../controllers/college')

const router = express.Router()

router.get('/', (req, res) => {
    res.json({
        message: 'Welcome to the Hostel-Bazaar Admin Service',
        time: new Date().toLocaleString(),
        ip: req.ip
    })
})

router.get('/all', CollegeController.getColleges)
router.post('/', CollegeController.addCollege)

router.get('*', (req, res) => {
    res.redirect('/admin')
})

module.exports = router