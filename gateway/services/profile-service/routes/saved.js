const express = require('express')
const passport = require('passport')
const savedController = require('../controllers/saved')

const router = express.Router()

router.get('/', (req, res) => {
    res.json({
        message: 'Welcome to the Hostel-Bazaar Profile Service',
        time: new Date().toLocaleString(),
        ip: req.ip
    })
})

router.get('/', passport.authenticate('jwt', { session: false }), savedController.getSaved) // ADMIN
router.post('/', passport.authenticate('jwt', { session: false }), savedController.addSaved) // ADMIN

router.get('*', (req, res) => {
    res.redirect('/profile')
})

module.exports = router