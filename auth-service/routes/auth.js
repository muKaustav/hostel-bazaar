const express = require('express')
const passport = require('passport')
const authController = require('../controllers/auth')
const { refresh, deleteRefresh } = require('../auth/authService')

const router = express.Router()

router.post('/signup', passport.authenticate('signup', { session: false }), authController.signup)
router.post('/login', authController.login)

router.get('/refresh', refresh)
router.delete('/refresh', deleteRefresh)

router.get('/verify/:token', authController.verify)

router.get('/protected', passport.authenticate('jwt', { session: false }), authController.protected)

module.exports = router