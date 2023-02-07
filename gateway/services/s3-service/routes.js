require('dotenv').config()
const aws = require('aws-sdk')
const multer = require('multer')
const express = require('express')
const Imagekit = require('imagekit')
const passport = require('passport')
const multerS3 = require('multer-s3')
const router = express.Router()

const imagekit = new Imagekit({
    publicKey: 'public_jBcJiauo9ub1zRYKp0V76V4ooLA=',
    privateKey: 'private_woQs88zWdfP5k+hRLi1eNlH5UxI=',
    urlEndpoint: 'https://ik.imagekit.io/lfzjxziqh/',
})

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
        bucket: 'imgkithb',
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
    singleUpload(req, res, async (err) => {
        if (err) {
            return res.status(422).send({ errors: [{ title: 'Image Upload Error', detail: err.message }] })
        }

        let url = imagekit.url({
            path: "/" + req.file.key,
        })

        return res.json({ 'imageUrl': url })
    })
})

router.get('/get-url', passport.authenticate('jwt', { session: false }), (req, res) => {
    let key = req.query.key

    let imageURL = imagekit.url({
        path: "/" + key,
        urlEndpoint: "https://ik.imagekit.io/lfzjxziqh/"
    })

    return res.json({ 'imageUrl': imageURL })
})

router.delete('/delete', passport.authenticate('jwt', { session: false }), (req, res) => {
    let key = req.query.key

    imagekit.deleteFile(key).then((response) => {
        res.json({ 'message': 'Image deleted successfully!' })
    }).catch((error) => {
        res.json({ 'message': 'Image deletion failed!' })
    })
})

module.exports = router