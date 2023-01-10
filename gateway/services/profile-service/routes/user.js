const express = require('express')
const passport = require('passport')
const userController = require('../controllers/user')

const router = express.Router()

router.get('/', (req, res) => {
    res.json({
        message: 'Welcome to the Hostel-Bazaar Profile Service',
        time: new Date().toLocaleString(),
        ip: req.ip
    })
})

router.get('/', passport.authenticate('jwt', { session: false }), userController.getUsers) // ADMIN

router.get('*', (req, res) => {
    res.redirect('/profile')
})

module.exports = router