const express = require('express')
const passport = require('passport')
const reviewController = require('../controllers/review')

const router = express.Router()

router.get('/', (req, res) => {
    res.json({
        message: 'Welcome to the Hostel-Bazaar Product Service',
        time: new Date().toLocaleString(),
        ip: req.ip
    })
})

router.get('/single', passport.authenticate('jwt', { session: false }), reviewController.getReview)
router.get('/:productId', passport.authenticate('jwt', { session: false }), reviewController.getReviews)
router.post('/single', passport.authenticate('jwt', { session: false }), reviewController.addReview)
router.put('/single', passport.authenticate('jwt', { session: false }), reviewController.updateReview)
router.delete('/single', passport.authenticate('jwt', { session: false }), reviewController.deleteReview)

router.get('*', (req, res) => {
    res.redirect('/product')
})

module.exports = router