const express = require('express')
const passport = require('passport')
const productController = require('../controllers/product')

const router = express.Router()

router.get('/', (req, res) => {
    res.json({
        message: 'Welcome to the Hostel-Bazaar Product Service',
        time: new Date().toLocaleString(),
        ip: req.ip
    })
})

router.get('/all', passport.authenticate('jwt', { session: false }), productController.getProducts)
router.get('/:category', passport.authenticate('jwt', { session: false }), productController.getProductsByCategory)
router.post('/', passport.authenticate('jwt', { session: false }), productController.addProduct)
router.post('/buy', passport.authenticate('jwt', { session: false }), productController.buy)

router.get('*', (req, res) => {
    res.redirect('/product')
})

module.exports = router