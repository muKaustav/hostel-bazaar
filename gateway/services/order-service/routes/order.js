const express = require('express')
const passport = require('passport')
const orderController = require('../controllers/order')

const router = express.Router()

router.get('/', (req, res) => {
    res.json({
        message: 'Welcome to the Hostel-Bazaar Order Service',
        time: new Date().toLocaleString(),
        ip: req.ip
    })
})

router.get('/me', passport.authenticate('jwt', { session: false }), orderController.getOrders)
router.get('/all', passport.authenticate('jwt', { session: false }), orderController.getAllOrders)
router.get('/last/:n', passport.authenticate('jwt', { session: false }), orderController.lastNOrders)
router.get('/user/last/:n', passport.authenticate('jwt', { session: false }), orderController.lastNOrdersByUser)
router.get('/pending', passport.authenticate('jwt', { session: false }), orderController.getPendingOrdersOfUser)
router.put('/editStatus', passport.authenticate('jwt', { session: false }), orderController.editOrderStatus)
router.get('/:orderId', passport.authenticate('jwt', { session: false }), orderController.getOrder)

router.get('*', (req, res) => {
    res.redirect('/order')
})

module.exports = router