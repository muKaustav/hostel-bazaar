const express = require('express')
const passport = require('passport')
const CollegeController = require('../controllers/college')

const router = express.Router()

router.get('/', CollegeController.getColleges)
router.post('/', CollegeController.addCollege)

module.exports = router