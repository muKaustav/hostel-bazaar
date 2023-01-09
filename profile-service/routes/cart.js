const express = require('express')
const passport = require('passport')
const cartController = require('../controllers/cart')

const router = express.Router()

router.get('/', passport.authenticate('jwt', { session: false }), cartController.getCarts) // ADMIN
router.post('/', passport.authenticate('jwt', { session: false }), cartController.addCart) // ADMIN
router.post('/add', passport.authenticate('jwt', { session: false }), cartController.addItemToCart) // USER
router.post('/delete', passport.authenticate('jwt', { session: false }), cartController.deleteItemFromCart) // USER
router.put('/update', passport.authenticate('jwt', { session: false }), cartController.updateQuantity) // USER
router.put('/increment', passport.authenticate('jwt', { session: false }), cartController.incrementQuantity) // USER
router.put('/decrement', passport.authenticate('jwt', { session: false }), cartController.decrementQuantity) // USER


module.exports = router