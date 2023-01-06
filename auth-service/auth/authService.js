require('dotenv').config()
const jwt = require('jsonwebtoken')
const UserModel = require('../models/user')

let generateAccessToken = (payload) => {
    return jwt.sign({ user: payload }, process.env.ACCESS_TOKEN_SECRET, { expiresIn: '15m' })
}

let generateRefreshToken = (payload) => {
    return jwt.sign(payload, process.env.REFRESH_TOKEN_SECRET)
}

let refresh = async (req, res) => {
    let refreshToken = req.body.token

    if (!refreshToken) {
        return res.status(401).send({
            success: false,
            message: 'No refresh token provided.'
        })
    }

    UserModel.findOne({ refreshToken: refreshToken })
        .exec((err, user) => {
            if (err) {
                return res.status(500).send({
                    success: false,
                    message: 'Error occurred while searching for user.'
                })
            }

            if (!user) {
                return res.status(404).send({
                    success: false,
                    message: 'User not found.'
                })
            }

            let payload = { id: user._id, email: user.email, role: user.role, hostel: user.hostel, room_number: user.room_number }

            let accessToken = generateAccessToken(payload)
            let newRefreshToken = generateRefreshToken(payload)

            user.refreshToken = newRefreshToken
            user.save()

            return res.status(200).send({
                success: true,
                message: 'Refresh token generated.',
                accessToken: "Bearer " + accessToken
            })
        })
}

deleteRefresh = async (req, res) => {
    let refreshToken = req.body.token

    if (!refreshToken) {
        return res.status(401).send({
            success: false,
            message: 'No refresh token provided.'
        })
    }

    UserModel.findOne({ refreshToken: refreshToken })
        .exec((err, user) => {
            if (err) {
                return res.status(500).send({
                    success: false,
                    message: 'Error occurred while searching for user.'
                })
            }

            if (!user) {
                return res.status(404).send({
                    success: false,
                    message: 'User not found.'
                })
            }

            user.refreshToken = null
            user.save()

            return res.status(200).send({
                success: true,
                message: 'Refresh token deleted.'
            })
        })
}

module.exports = { generateAccessToken, generateRefreshToken, refresh, deleteRefresh }