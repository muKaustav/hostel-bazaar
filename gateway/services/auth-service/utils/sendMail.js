const nodemailer = require('nodemailer')

let sendMail = (email, uniqueString) => {
    let Transport = nodemailer.createTransport({
        service: "Gmail",
        auth: {
            user: process.env.AUTH_EMAIL,
            pass: process.env.AUTH_PASSWORD
        }
    })

    let mailOptions = {
        from: "Hostel Bazaar",
        to: email,
        subject: "Hostel Bazaar | Verification Email",
        html: "Click <a href=http://" + process.env.IP  + "/auth/verify/" + uniqueString + "> here</a> to verify your email. Thanks!"
    }

    Transport.sendMail(mailOptions, (error, response) => {
        if (error) {
            console.log(error)
        } else {
            console.log("Message sent")
        }
    })
}

module.exports = sendMail