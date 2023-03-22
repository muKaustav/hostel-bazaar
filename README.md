<h1 align="center">Hostel Bazaar: E-commerce for the Hostel 🔗</h1>
<p align = center>
    <img alt="Project Logo" src="https://raw.githubusercontent.com/muKaustav/hostel-bazaar/main/assets/hbgithub.jpg" target="_blank" />
</p>
<h2 align='center'>A microserviced e-commerce application.</h2><br/>

## 📚 | Introduction

- Hostel Bazaar is an e-commerce application built with microservices in mind.
- It uses Redis as a cache, and MongoDB as a NoSQL database.
- It uses express-gateway that acts as a API Gateway for the microservices.
- It uses RabbitMQ as a message broker for asynchronous communication between microservices.

### _**Disclaimer**_

- This is a demo application of an E-commerce application following the guidelines of the [Microservices Architecture](https://microservices.io/patterns/microservices.html) pattern.

<br/>

## 🚀 | Usage

- Install Docker Desktop and NodeJS for a quick setup.
- Clone this repository:<br>    

```sh
git clone https://github.com/muKaustav/hostel-bazaar.git
```

- Find the .env.example file in the root directory and rename it to .env.<br>

- Fill in the required environment variables in the .env file.<br>

- Enjoy the project! 😉

<br/>

## 📘 | System Design Schematic

<p align = center>
    <img alt="getURL" src="https://raw.githubusercontent.com/muKaustav/ShortURL/master/client/src/assets/images/getURLs.png" target="_blank" />
    <img alt="redirect" src="https://raw.githubusercontent.com/muKaustav/ShortURL/master/client/src/assets/images/redirect.png" target="_blank" />
</p>

<br/>

## ⌛ | Architectural Discussion

- The _**availability**_ of the application can be improved by using multiple Zookeeper instances, replicas of the DB, and a distributed cache, thus increasing the fault tolerance of the architecture.
- Adding load balancers in between the following improves the performance of the application, and reduces the load on any particular instance:
  - client and server
  - server and DB
  - server and cache
- _**CAP Theorem**_:
  - We opt for an _**eventually consistent approach**_, as in case of a network partition, a URL Shortener should have low latency and high throughput at all times. <br/>
  - Redirection of the user to the original URL should always have low latency as it directly impacts the business aspect of the application.
  - We don't opt for a _**strongly consistent approach**_, as we would have to wait for the data to be replicated across the cluster, which decreases the availability and increases the latency of the application, thus impacting the user experience negatively.

<br/>

## 💻 | References

- [TinyURL System Design](https://www.codekarle.com/system-design/TinyUrl-system-design.html)
- [System Design : Scalable URL shortener service like TinyURL](https://medium.com/@sandeep4.verma/system-design-scalable-url-shortener-service-like-tinyurl-106f30f23a82)
- [An Illustrated Proof of the CAP Theorem](https://mwhittaker.github.io/blog/an_illustrated_proof_of_the_cap_theorem/)
- [What is eventual consistency and why should you care about it?](https://www.keboola.com/blog/eventual-consistency)
- [Redis Documentation](https://redis.io/documentation)
- [Apache Zookeeper Documentation](https://zookeeper.apache.org/doc/r3.7.0/index.html)
- [Nginx HTTP Load Balancing Documentation](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/)
- [Docker Documentation](https://docs.docker.com/language/nodejs/)
- [Kompose Documentation](https://kompose.io/user-guide/)

<br/>

## 🍻 | Contributing

Contributions, issues and feature requests are welcome.<br>
Feel free to check [issues page](https://github.com/muKaustav/ShortURL/issues) if you want to contribute.

<br/>

## 🧑🏽 | Author

**Kaustav Mukhopadhyay**

- Linkedin: [@kaustavmukhopadhyay](https://www.linkedin.com/in/kaustavmukhopadhyay/)
- Github: [@muKaustav](https://github.com/muKaustav)

<br/>

## 🙌 | Show your support

Drop a ⭐️ if this project helped you!

<br/>

## 📝 | License

Copyright © 2021 [Kaustav Mukhopadhyay](https://github.com/muKaustav).<br />
This project is [MIT](./LICENSE) licensed.

---
