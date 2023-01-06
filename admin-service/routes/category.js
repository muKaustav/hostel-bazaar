const express = require('express')
const passport = require('passport')
const CategoryController = require('../controllers/category')

const router = express.Router()

router.get('/', CategoryController.getCategories)
router.post('/', passport.authenticate('jwt', { session: false }), CategoryController.addCategory)

module.exports = router