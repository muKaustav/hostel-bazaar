require('dotenv').config()
const passport = require('passport')
let { generateAccessToken } = require('../auth/authService')
const UserModel = require('../models/user')
const CartModel = require('../models/cart')
const SavedModel = require('../models/saved')

let signup = async (req, res, next) => {
    return res.status(200).send({
        success: true,
        message: 'Verfication email sent.'
    })
}

let login = async (req, res, next) => {
    passport.authenticate('login',
        async (err, user, info) => {
            try {
                if (err || !user) {
                    return res.status(401).send({
                        success: false,
                        message: info.message
                    })
                }

                req.login(
                    user, { session: false },
                    async (error) => {
                        if (error) {
                            return res.status(401).send({
                                success: false,
                                error: error.message
                            })
                        }

                        let payload = { _id: user._id, email: user.email, role: user.role, college: user.college, hostel: user.hostel, room_number: user.room_number }
                        let accessToken = generateAccessToken(payload)

                        console.log({
                            success: true,
                            message: 'Successfully logged in.',
                            user: user._id,
                        })

                        return res.status(200).send({
                            success: true,
                            message: 'Successfully logged in.',
                            accessToken: "Bearer " + accessToken
                        })
                    }
                )
            } catch (error) {
                return next(error)
            }
        }
    )(req, res, next)
}

let verify = async (req, res) => {
    let { token } = req.params

    const user = await UserModel.findOne({ verificationToken: token })

    if (!user)
        return res.json({ message: 'Invalid token.' })

    user.isVerified = true
    user.verificationToken = null

    await user.save()

    console.log("Account verified. " + user)

    await CartModel.create({ userId: user._id })
        .then(async () => {
            await SavedModel.create({ userId: user._id })
                .then(() => {
                    return res.status(500).send({
                        success: true,
                        message: 'Account verified. Cart and Saved created.'
                    })
                })
                .catch(err => {
                    return res.status(500).send({
                        success: false,
                        message: 'Account verified. Cart created. Saved not created.',
                        error: err
                    })
                })
        })
        .catch(err => {
            return res.status(500).send({
                success: false,
                message: 'Account verified. Cart not created.',
                error: err
            })
        })
}

let protected = async (req, res) => {
    return res.status(200).send({
        success: true,
        message: 'Protected route.',
        user: req.user
    })
}

module.exports = { signup, login, verify, protected }