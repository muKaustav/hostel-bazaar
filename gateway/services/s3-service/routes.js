require('dotenv').config()
const aws = require('aws-sdk')
const multer = require('multer')
const multerS3 = require('multer-s3')
const express = require('express')
const passport = require('passport')
const router = express.Router()

aws.config.update({
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    region: 'ap-south-1'
})

const s3 = new aws.S3()

const fileFilter = (req, file, cb) => {
    if (file.mimetype === 'image/jpeg' || file.mimetype === 'image/png') {
        cb(null, true)
    } else {
        cb(new Error('Invalid file type, only JPEG and PNG is allowed!'), false)
    }
}

let upload = multer({
    fileFilter,
    storage: multerS3({
        ACL: 'public-read',
        s3,
        bucket: 'hostel-bazaar',
        metadata: (req, file, cb) => {
            cb(null, { fieldName: 'TESTING_METADATA' })
        },
        key: (req, file, cb) => {
            const ext = file.originalname.split('.').pop()
            cb(null, Date.now().toString() + '.' + ext)
        }
    })
})

const singleUpload = upload.single('image')

router.post('/image-upload', passport.authenticate('jwt', { session: false }), (req, res) => {
    singleUpload(req, res, (err) => {
        if (err) {
            return res.status(422).send({ errors: [{ title: 'Image Upload Error', detail: err.message }] })
        }

        return res.json({ 'imageUrl': req.file.location })
    })
})

router.get('/get-url', passport.authenticate('jwt', { session: false }), (req, res) => {
    const params = {
        Bucket: 'hostel-bazaar',
        Key: req.query.key
    }

    s3.getSignedUrl('getObject', params, (err, url) => {
        if (err) {
            console.log(err, err.stack)
        } else {
            res.json({ 'imageUrl': url })
        }
    })
})

router.delete('/delete', passport.authenticate('jwt', { session: false }), (req, res) => {
    const params = {
        Bucket: 'hostel-bazaar',
        Key: req.query.key
    }

    s3.deleteObject(params, (err, data) => {
        if (err) {
            console.log(err, err.stack)
        } else {
            console.log(data)
            res.json({ 'message': 'Image deleted successfully' })
        }
    })
})

module.exports = router