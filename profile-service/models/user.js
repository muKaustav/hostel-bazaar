const bcrypt = require("bcryptjs")
const mongoose = require("mongoose")
const validator = require('validator')

const UserSchema = new mongoose.Schema({
    name: {
        type: String,
        required: [true, "Please provide name"],
        minlength: 3,
        maxlength: 50,
    },

    email: {
        type: String,
        unique: true,
        required: [true, "Please provide email"],
        validate: {
            validator: validator.isEmail,
            message: "Please provide valid email",
        },
    },

    password: { type: String },

    verificationToken: { type: String },

    isVerified: { type: Boolean, default: false },

    profile_image: { type: String, default: "default.jpg" },

    hostel: { type: mongoose.Schema.Types.ObjectId, ref: "Hostel", required: true },

    role: { type: String, enum: ["USER", "ADMIN"], default: "USER" },

    room_number: { type: String },

    accessToken: { type: String },

    refreshToken: { type: String }
}, { timestamps: true })

UserSchema.methods.isValidPassword = async function (password) {
    const user = this
    const compare = await bcrypt.compare(password, user.password)

    return compare
}

const UserModel = mongoose.model('User', UserSchema)

module.exports = UserModel