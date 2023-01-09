module.exports = {
    apps: [
        {
            name: "admin",
            cwd: "./admin-service/server.js",
            script: "npm",
            args: "start",
            env: {
                NODE_ENV: "production"
            }
        },
        {
            name: "auth",
            cwd: "./auth-service/server.js",
            script: "npm",
            args: "start",
            env: {
                NODE_ENV: "production"
            }
        },
        {
            name: "order",
            cwd: "./order-service/server.js",
            script: "npm",
            args: "start",
            env: {
                NODE_ENV: "production"
            }
        },
        {
            name: "product",
            cwd: "./product-service/server.js",
            script: "npm",
            args: "start",
            env: {
                NODE_ENV: "production"
            }
        },
        {
            name: "profile",
            cwd: "./profile-service/server.js",
            script: "npm",
            args: "start",
            env: {
                NODE_ENV: "production"
            }
        }
    ]
}