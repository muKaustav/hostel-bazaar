const express = require('express')
const passport = require('passport')
const authController = require('../controllers/auth')
const path = require('path')
const { refresh, deleteRefresh } = require('../auth/authService')

const router = express.Router()

router.get('/', (req, res) => {
    res.json({
        message: 'Welcome to the Hostel-Bazaar Authentication Service',
        time: new Date().toLocaleString(),
        ip: req.ip
    })
})

router.post('/signup', passport.authenticate('signup', { session: false }), authController.signup)
router.post('/login', authController.login)

router.get('/refresh', refresh)
router.delete('/refresh', deleteRefresh)

router.get('/verify/:token', authController.verify)

router.get('/protected', passport.authenticate('jwt', { session: false }), authController.protected)

router.get('/success', (req, res) => { 
    res.sendFile(path.join(__dirname, '../public', 'verify.html'))
})

router.get('*', (req, res) => {
    res.redirect('/auth')
})

module.exports = router
