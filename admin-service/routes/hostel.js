const express = require('express')
const passport = require('passport')
const HostelController = require('../controllers/hostel')

const router = express.Router()

router.get('/', HostelController.getHostels)
router.post('/', passport.authenticate('jwt', { session: false }), HostelController.addHostel)

module.exports = router