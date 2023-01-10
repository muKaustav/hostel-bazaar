module.exports = {
    apps: [{
        name: "admin",
        script: "./admin-service/server.js",
        watch: true,
        env: {
            NODE_ENV: "production",
            CATEGORY_DB_URI: 'mongodb+srv://access:access2022@cluster0.rphmddt.mongodb.net/hb-products',
            HOSTEL_DB_URI: 'mongodb+srv://access:access2022@cluster0.rphmddt.mongodb.net/hb-profile',
            COLLEGE_DB_URI: 'mongodb+srv://access:access2022@cluster0.rphmddt.mongodb.net/hb-profile',
            ACCESS_TOKEN_SECRET: '8fbf236d964f9a57cee7712bb49c88b9300937f0265d125732807b44e1843fe8'

        }
    }, {
        name: "auth",
        script: "./auth-service/server.js",
        watch: true,
        env: {
            NODE_ENV: "production",
            AUTH_EMAIL: 'hostelbazaar22@gmail.com',
            AUTH_PASSWORD: 'thmsabwidcjczjjb',
            PORT: 5001,
            ACCESS_TOKEN_SECRET: '8fbf236d964f9a57cee7712bb49c88b9300937f0265d125732807b44e1843fe8',
            REFRESH_TOKEN_SECRET: '0356b4a3bf19b33dce343a06ea20f9266fc84587b51eb977c5e046fa76cb4fc5',
            AUTH_DB_URI: 'mongodb+srv://access:access2022@cluster0.rphmddt.mongodb.net/hb-auth',
            PRODUCT_DB_URI: 'mongodb+srv://access:access2022@cluster0.rphmddt.mongodb.net/hb-products',
            CATEGORY_DB_URI: 'mongodb+srv://access:access2022@cluster0.rphmddt.mongodb.net/hb-products',
            HOSTEL_DB_URI: 'mongodb+srv://access:access2022@cluster0.rphmddt.mongodb.net/hb-profile',
            CART_DB_URI: 'mongodb+srv://access:access2022@cluster0.rphmddt.mongodb.net/hb-profile',
            SAVED_DB_URI: 'mongodb+srv://access:access2022@cluster0.rphmddt.mongodb.net/hb-profile',
            USER_DB_URI: 'mongodb+srv://access:access2022@cluster0.rphmddt.mongodb.net/hb-profile',
            COLLEGE_DB_URI: 'mongodb+srv://access:access2022@cluster0.rphmddt.mongodb.net/hb-profile'
        }
    }, {
        name: "order",
        script: "./order-service/server.js",
        watch: true,
        env: {
            NODE_ENV: "production",
            ACCESS_TOKEN_SECRET: '8fbf236d964f9a57cee7712bb49c88b9300937f0265d125732807b44e1843fe8',
            ORDER_DB_URI: 'mongodb+srv://access:access2022@cluster0.rphmddt.mongodb.net/hb-order',
            USER_DB_URI: 'mongodb+srv://access:access2022@cluster0.rphmddt.mongodb.net/hb-profile',
            PRODUCT_DB_URI: 'mongodb+srv://access:access2022@cluster0.rphmddt.mongodb.net/hb-products',
            CATEGORY_DB_URI: 'mongodb+srv://access:access2022@cluster0.rphmddt.mongodb.net/hb-products',
            HOSTEL_DB_URI: 'mongodb+srv://access:access2022@cluster0.rphmddt.mongodb.net/hb-profile',
            COLLEGE_DB_URI: 'mongodb+srv://access:access2022@cluster0.rphmddt.mongodb.net/hb-profile',
            RABBITMQ_URI: 'amqp://myuser:mypassword@localhost:5672'
        }
    }, {
        name: "product",
        script: "./product-service/server.js",
        watch: true,
        env: {
            NODE_ENV: "production",
            ACCESS_TOKEN_SECRET: '8fbf236d964f9a57cee7712bb49c88b9300937f0265d125732807b44e1843fe8',
            USER_DB_URI: 'mongodb+srv://access:access2022@cluster0.rphmddt.mongodb.net/hb-profile',
            PRODUCT_DB_URI: 'mongodb+srv://access:access2022@cluster0.rphmddt.mongodb.net/hb-products',
            HOSTEL_DB_URI: 'mongodb+srv://access:access2022@cluster0.rphmddt.mongodb.net/hb-profile',
            COLLEGE_DB_URI: 'mongodb+srv://access:access2022@cluster0.rphmddt.mongodb.net/hb-profile',
            RABBITMQ_URI: 'amqp://myuser:mypassword@localhost:5672'
        }
    }, {
        name: "profile",
        script: "./profile-service/server.js",
        watch: true,
        env: {
            NODE_ENV: "production",
            ACCESS_TOKEN_SECRET: '8fbf236d964f9a57cee7712bb49c88b9300937f0265d125732807b44e1843fe8',
            PRODUCT_DB_URI: 'mongodb+srv://access:access2022@cluster0.rphmddt.mongodb.net/hb-products',
            PROFILE_DB_URI: 'mongodb+srv://access:access2022@cluster0.rphmddt.mongodb.net/hb-profile',
            HOSTEL_DB_URI: 'mongodb+srv://access:access2022@cluster0.rphmddt.mongodb.net/hb-profile',
            CATEGORY_DB_URI: 'mongodb+srv://access:access2022@cluster0.rphmddt.mongodb.net/hb-products',
            COLLEGE_DB_URI: 'mongodb+srv://access:access2022@cluster0.rphmddt.mongodb.net/hb-profile'
        }
    }]
}
