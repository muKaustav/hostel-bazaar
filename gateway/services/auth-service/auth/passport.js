const bcrypt = require("bcryptjs")
const passport = require('passport')
const { v4: uuidv4 } = require('uuid')
const UserModel = require('../models/user')
const sendMail = require('../utils/sendMail')
const JWTstrategy = require('passport-jwt').Strategy
const ExtractJWT = require('passport-jwt').ExtractJwt
const localStrategy = require('passport-local').Strategy
const { generateRefreshToken } = require('../auth/authService')

passport.use('signup',
    new localStrategy({ usernameField: 'email', passwordField: 'password', passReqToCallback: true },
        async (req, email, password, done) => {
            try {
                const { name, college, profile_image, hostel, room_number, role, UPI, contact } = req.body

                password = await bcrypt.hash(password, 10)
                emailVerificationToken = uuidv4()

                await UserModel.create({ name, email, password, college, verificationToken: emailVerificationToken, isVerified: false, profile_image, hostel, room_number, role, UPI, contact })
                    .then(async (user) => {
                        let refreshToken = generateRefreshToken({ _id: user._id, email: user.email })

                        await UserModel.findOneAndUpdate({ _id: user._id }, { refreshToken: refreshToken })
                            .then(async (user) => {
                                sendMail(email, emailVerificationToken)

                                return done(null, user)
                            }).catch((err) => {
                                return done(err)
                            })
                    }).catch((err) => {
                        return done(err)
                    })
            } catch (error) { done(error) }
        }
    )
)

passport.use('login',
    new localStrategy({ usernameField: 'email', passwordField: 'password' },
        async (email, password, done) => {
            try {
                const user = await UserModel.findOne({ email })

                if (!user)
                    return done(null, false, { message: 'User not found' })

                if (!user.isVerified)
                    return done(null, false, { message: 'Please verify your account' })

                if (!await user.isValidPassword(password))
                    return done(null, false, { message: 'Wrong Password' })

                let payload = { _id: user._id, email: user.email, role: user.role, college: user.college, hostel: user.hostel, room_number: user.room_number }

                let refreshToken = generateRefreshToken(payload)

                await UserModel.findOneAndUpdate({ _id: user._id }, { refreshToken: refreshToken })
                    .then(async (user) => {
                        return done(null, user, { message: 'Logged in Successfully' })
                    }).catch((err) => {
                        return done(err)
                    })
            } catch (error) { return done(error) }
        }
    )
)

passport.use(
    new JWTstrategy(
        {
            secretOrKey: process.env.ACCESS_TOKEN_SECRET,
            jwtFromRequest: ExtractJWT.fromAuthHeaderAsBearerToken()
        },
        async (token, done) => {
            try {
                return done(null, token.user)
            } catch (error) { done(error) }
        }
    )
)