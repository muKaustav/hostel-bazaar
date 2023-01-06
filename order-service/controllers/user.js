const UserModel = require('../models/user')

let getUsers = (req, res) => {
    let user = req.user

    if (user.role !== 'ADMIN') {
        return res.status(403).json({
            success: false,
            message: 'You are not authorized to perform this action.'
        })
    }

    UserModel.find({}, (err, users) => {
        if (err) {
            res.send(err)
        } else {
            res.send(users)
        }
    })
}

module.exports = { getUsers }