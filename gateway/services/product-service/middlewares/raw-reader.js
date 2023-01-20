let rawReader = async (req, res, next) => {
    var data = ""
    req.on('data', (chunk) => { data += chunk })
    req.on('end', () => {
        req.rawBody = data
        next()
    })
}

module.exports = rawReader