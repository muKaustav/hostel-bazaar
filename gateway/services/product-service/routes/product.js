const express = require('express')
const passport = require('passport')
let rawReader = require('../middlewares/raw-reader')
const productController = require('../controllers/product')

const router = express.Router()

router.get('/', (req, res) => {
    res.json({
        message: 'Welcome to the Hostel-Bazaar Product Service',
        time: new Date().toLocaleString(),
        ip: req.ip
    })
})

router.get('/search/:query', passport.authenticate('jwt', { session: false }), productController.search)
router.get('/searchUnique/:query', passport.authenticate('jwt', { session: false }), productController.searchUnique)
router.get('/all', passport.authenticate('jwt', { session: false }), productController.getProducts)
router.get('/category/:category', passport.authenticate('jwt', { session: false }), productController.getProductsByCategory)
router.get('/:productId', passport.authenticate('jwt', { session: false }), productController.getProduct)
// router.get('/seller/:sellerId', passport.authenticate('jwt', { session: false }), productController.getProductsBySeller)
router.post('/', passport.authenticate('jwt', { session: false }), productController.addProduct)
router.post('/buy', passport.authenticate('jwt', { session: false }), rawReader, productController.buy)

router.get('*', (req, res) => {
    res.redirect('/product')
})

module.exports = router