const express = require('express')
const passport = require('passport')
const orderController = require('../controllers/order')

const router = express.Router()

router.get('/all', passport.authenticate('jwt', { session: false }), orderController.getAllOrders)
router.get('/:orderId', passport.authenticate('jwt', { session: false }), orderController.getOrder)
router.get('/', passport.authenticate('jwt', { session: false }), orderController.getOrders)
router.put('/editStatus', passport.authenticate('jwt', { session: false }), orderController.editOrderStatus)

module.exports = router