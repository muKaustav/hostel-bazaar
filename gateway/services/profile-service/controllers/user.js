const UserModel = require('../models/user')

let getUsers = (req, res) => {
    let user = req.user

    if (user.role !== 'ADMIN') {
        return res.status(403).json({
            success: false,
            message: 'You are not authorized to perform this action.'
        })
    }

    try {
        UserModel.find({}, (err, users) => {
            if (err) {
                res.send(err)
            } else {
                res.send(users)
            }
        })
    } catch (err) {
        return res.status(500).json({
            success: false,
            message: 'Internal Server Error'
        })
    }
}

let getUser = (req, res) => {
    let user = req.user

    try {
        UserModel.findOne({ _id: user._id }, (err, user) => {
            if (err) {
                return res.status(500).json({
                    success: false,
                    message: 'Internal Server Error'
                })
            }

            return res.status(200).json({
                success: true,
                message: 'User found.',
                user: user
            })
        })
    } catch (err) {
        return res.status(500).json({
            success: false,
            message: 'Internal Server Error'
        })
    }
}

let editUser = (req, res) => {
    let user = req.user

    try {
        UserModel.findOneAndUpdate({ _id: user._id }, req.body, { new: true }, (err, user) => {
            if (err) {
                return res.status(500).json({
                    success: false,
                    message: 'Internal Server Error'
                })
            }

            return res.status(200).json({
                success: true,
                user: user
            })
        })
    } catch (err) {
        return res.status(500).json({
            success: false,
            message: 'Internal Server Error'
        })
    }
}

let deleteUser = (req, res) => {
    let user = req.user

    try {
        UserModel.findOneAndDelete({ _id: user._id }, (err, user) => {
            if (err) {
                return res.status(500).json({
                    success: false,
                    message: 'Internal Server Error'
                })
            }
            
            return res.status(200).json({
                success: true,
                message: 'User deleted.'
            })
        })
    } catch (err) {
        return res.status(500).json({
            success: false,
            message: 'Internal Server Error'
        })
    }
}

module.exports = { getUsers, getUser, editUser, deleteUser }