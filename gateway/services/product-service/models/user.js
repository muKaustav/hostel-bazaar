const bcrypt = require("bcryptjs")
const mongoose = require("mongoose")
const validator = require('validator')
let Hostel = require('./hostel')
let College = require('./college')

let UserDB = mongoose.createConnection(process.env.USER_DB_URI, { useNewUrlParser: true, useUnifiedTopology: true })

const UserSchema = new mongoose.Schema({
    name: {
        type: String,
        required: [true, "Please provide name"],
        minlength: 3,
        maxlength: 50,
    },

    nickname: {
        type: String,
        minlength: 3,
        maxlength: 15,
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

    contact: { type: String, unique: true, sparse: true },

    verificationToken: { type: String },

    isVerified: { type: Boolean, default: false },

    profile_image: { type: String, default: "default.jpg" },

    hostel: { type: mongoose.Schema.Types.ObjectId, ref: Hostel, required: true },
    
    college: { type: mongoose.Schema.Types.ObjectId, ref: College, required: true },

    UPI: { type: String, unique: true, sparse: true },
    
    role: { type: String, enum: ["USER", "ADMIN"], default: "USER" },

    rating: { type: Number, default: 0 },

    room_number: { type: String },

    accessToken: { type: String },

    refreshToken: { type: String }
}, { timestamps: true })

UserSchema.methods.isValidPassword = async function (password) {
    const user = this
    const compare = await bcrypt.compare(password, user.password)

    return compare
}

const UserModel = UserDB.model('User', UserSchema)

module.exports = UserModel