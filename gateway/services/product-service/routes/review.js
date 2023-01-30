const express = require('express')
const passport = require('passport')
const reviewController = require('../controllers/review')

const router = express.Router()

router.get('/single', passport.authenticate('jwt', { session: false }), reviewController.getReview)
router.get('/:productId', passport.authenticate('jwt', { session: false }), reviewController.getReviews)
router.post('/single', passport.authenticate('jwt', { session: false }), reviewController.addReview)
router.put('/single', passport.authenticate('jwt', { session: false }), reviewController.updateReview)
router.delete('/single', passport.authenticate('jwt', { session: false }), reviewController.deleteReview)

module.exports = router