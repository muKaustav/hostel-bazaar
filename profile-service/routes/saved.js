const express = require('express')
const passport = require('passport')
const savedController = require('../controllers/saved')

const router = express.Router()

router.get('/', passport.authenticate('jwt', { session: false }), savedController.getSaved) // ADMIN
router.post('/', passport.authenticate('jwt', { session: false }), savedController.addSaved) // ADMIN

module.exports = router