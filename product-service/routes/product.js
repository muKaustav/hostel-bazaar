const express = require('express')
const passport = require('passport')
const productController = require('../controllers/product')

const router = express.Router()

router.get('/', passport.authenticate('jwt', { session: false }), productController.getProducts)
router.get('/:category', passport.authenticate('jwt', { session: false }), productController.getProductsByCategory)
router.post('/', passport.authenticate('jwt', { session: false }), productController.addProduct)
router.post('/buy', passport.authenticate('jwt', { session: false }), productController.buy)

module.exports = router