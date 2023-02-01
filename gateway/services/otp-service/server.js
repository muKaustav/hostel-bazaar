require('dotenv').config()
const express = require('express')
const accountSid = process.env.TWILIO_ACCOUNT_SID
const authToken = process.env.TWILIO_AUTH_TOKEN
const client = require('twilio')(accountSid, authToken)

const app = express()
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

app.post('/otp/send-otp', (req, res) => {
    let number = req.body.number

    try {
        client.verify.v2.services(process.env.TWILIO_VERIFY_SERVICE_SID)
            .verifications
            .create({ to: number, channel: 'whatsapp' })
            .then(verification => {
                console.log(verification.accountSid)
                res.json({
                    message: 'OTP sent successfully',
                    status: verification.status
                })
            }).catch(err => { 
                console.log(err)
                res.json({
                    message: 'Error sending OTP',
                    status: 'failed'
                })
            })
    } catch (err) {
        console.log(err)
        res.json({
            message: 'Error sending OTP',
            status: 'failed'
        })
    }

})

app.post('/otp/verify-otp', (req, res) => {
    let number = req.body.number
    let otp = req.body.otp

    try {
        client.verify.v2.services(process.env.TWILIO_VERIFY_SERVICE_SID)
            .verificationChecks
            .create({ to: number, code: otp })
            .then(verification_check => {
                console.log(verification_check.status)

                if (verification_check.status === 'approved') {
                    res.json({
                        message: 'OTP verified successfully',
                        status: verification_check.status
                    })
                } else if (verification_check.status === 'pending') {
                    res.json({
                        message: 'OTP verification pending',
                        status: verification_check.status
                    })
                }
            }).catch(err => {
                console.log(err)
                res.json({
                    message: 'Error verifying OTP',
                    status: 'failed'
                })
            })
    } catch (err) {
        console.log(err)
        res.json({
            message: 'Error verifying OTP',
            status: 'failed'
        })
    }
})

let PORT = process.env.PORT || 5006

app.listen(5006, () => {
    console.log(`OTP service is running on port ${PORT}`)
})
