const express = require('express')
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
        UserModel.find({ _id: user._id })
            .select('+_id +name +email +profile_image +hostel +college +room_number +UPI -password -role -__v -verificationToken -createdAt -updatedAt -refreshToken')
            .exec((err, userDoc) => {
                if (err) {
                    return res.status(500).send(err)
                }

                return res.status(200).send(userDoc)
            })
    } catch (err) {
        return res.status(500).send('Internal Server Error')
    }
}

let getUserById = (req, res) => {
    let user = req.params.id

    try {
        UserModel.find({ _id: user })
            .select('+_id +name +email +profile_image +hostel +college +room_number +UPI -password -role -__v -verificationToken -createdAt -updatedAt -refreshToken')
            .exec((err, userDoc) => {
                if (err) {
                    return res.status(500).send(err)
                }

                return res.status(200).send(userDoc)
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
        UserModel.findOneAndUpdate({ _id: user._id }, req.body, { new: true })
            .select('+_id +name +email +profile_image +hostel +college +room_number +UPI -password -role -__v -verificationToken -createdAt -updatedAt -refreshToken')
            .exec((err, user) => {
                if (err) {
                    return res.status(500).json({
                        success: false,
                        message: 'Internal Server Error'
                    })
                }

                res.status(200).json({
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
        UserModel.findOneAndDelete({ _id: user._id })
            .select('+_id +name +email +profile_image +hostel +college +room_number +UPI -password -role -__v -verificationToken -createdAt -updatedAt -refreshToken')
            .exec((err, user) => {
                if (err) {
                    return res.status(500).json({
                        success: false,
                        message: 'Internal Server Error'
                    })
                }

                res.status(200).json({
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

module.exports = { getUsers, getUser, editUser, deleteUser, getUserById }