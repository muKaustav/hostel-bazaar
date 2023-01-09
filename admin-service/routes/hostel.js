const express = require('express')
const passport = require('passport')
const HostelController = require('../controllers/hostel')

const router = express.Router()

router.get('/', HostelController.getHostels)
router.post('/', HostelController.addHostel)

module.exports = router