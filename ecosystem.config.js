module.exports = {
    apps: [{
        name: "admin",
        script: "./admin-service/server.js",
        watch: true,
        env: {
            NODE_ENV: "production"
        }
    }, {
        name: "auth",
        script: "./auth-service/server.js",
        watch: true,
        env: {
            NODE_ENV: "production"
        }
    }, {
        name: "order",
        script: "./order-service/server.js",
        watch: true,
        env: {
            NODE_ENV: "production"
        }
    }, {
        name: "product",
        script: "./product-service/server.js",
        watch: true,
        env: {
            NODE_ENV: "production"
        }
    }, {
        name: "profile",
        script: "./profile-service/server.js",
        watch: true,
        env: {
            NODE_ENV: "production"
        }
    }]
}