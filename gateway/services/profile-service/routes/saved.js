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

router.post('/create', passport.authenticate('jwt', { session: false }), savedController.createSaved)
router.get('/me', passport.authenticate('jwt', { session: false }), savedController.getSaved) // ADMIN
router.post('/add', passport.authenticate('jwt', { session: false }), savedController.addSaved)
router.post('/rm', passport.authenticate('jwt', { session: false }), savedController.removeSaved)

router.get('*', (req, res) => {
    res.redirect('/profile')
})

module.exports = router