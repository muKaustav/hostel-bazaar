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

router.get('/all', passport.authenticate('jwt', { session: false }), userController.getUsers) // ADMIN
router.get('/me', passport.authenticate('jwt', { session: false }), userController.getUser) // USER
router.put('/me', passport.authenticate('jwt', { session: false }), userController.editUser) // USER
router.delete('/me', passport.authenticate('jwt', { session: false }), userController.deleteUser) // USER


router.get('*', (req, res) => {
    res.redirect('/profile')
})

module.exports = router