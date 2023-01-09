const express = require('express')
const passport = require('passport')
const userController = require('../controllers/user')

const router = express.Router()

router.get('/', passport.authenticate('jwt', { session: false }), userController.getUsers) // ADMIN

module.exports = router