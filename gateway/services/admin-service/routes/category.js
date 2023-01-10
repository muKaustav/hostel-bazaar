const express = require('express')
const passport = require('passport')
const CategoryController = require('../controllers/category')

const router = express.Router()

router.get('/', (req, res) => {
    res.json({
        message: 'Welcome to the Hostel-Bazaar Admin Service',
        time: new Date().toLocaleString(),
        ip: req.ip
    })
})

router.get('/all', CategoryController.getCategories)
router.post('/', CategoryController.addCategory)

router.get('*', (req, res) => {
    res.redirect('/admin')
})

module.exports = router