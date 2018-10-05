## Chapter 04 - Application Architectures

1. Describe the single-machine, three-tier, and four-tier web application architectures.
  * Single Machine: Uses one machine to provides web access to the website or web application, and stores all data/content on the same machine.
  * Three-tier: It uses a load balancer to distribute incoming connections between 3 different web servers. These 3 servers serve the applications and/or webpages, then all obtain data from the same data server.
  * Four-tier: Similar to the three-tier architecture, except that multiple frontend web servers will serve the application from separate servers that host and run the application. These application servers then contact a central data server, and use/serve data from there.

2. Describe how a single-machine web server, which uses a database to generate content, might evolve to a three-tier web server. How would this be done with minimal downtime?
This can be done with minimal downtime by copying the database data from the single-machine and copying that to a data server, then placing the single machine behind a load balancer with a few other machines, to evolve into a three-tier service

3. Describe the common web service architectures, in order from smallest to largest.
Single machine, three-tier, and then four-tier

4. Describe how different local load balancer types work and what their pros and cons are. You may choose to make a comparison chart.
  * DNS Round Robin: Works by having all IP addresses listed in the DNS entry for the web server. All browsers will receive all the IP addresses of the replicas, but will randomly choose one to connect to. This is beneficial since load would be balanced evenly, and no hardware needs to be used, and it's free. Although it is difficult to control, especially if a replica goes down, as browsers will still try to connect to the dead replica. There is also no way to control the load.
  * L4 and L3: These first receive a TCP session and then use either the network or session layer respectively to track and identify the connection. Packets get sent through these balancers and then to a replica server, and will always communicate with the same server for that TCP session. L3 servers track the sessions based on IP, while L4 tracks using IP and ports. These balancers are fast, but could potentially overload a replica, if too many TCP sessions are created, as they will send data to the same replica if its coming from the same server, regardless to the number of sessions created.
  * L7: Works similarly to L3 and L4, but uses the application layer to see which replica should receive requests based on richer data, such as cookies, headers, URLs, etc...). This could used to mark a browser to be forwarded to a fast replica.

5. What is “shared state” and how is it maintained between replicas?
Shared state is sharing data from one server, such as a frontend with another, such as a backend. It's maintained between replicas by using a shared storage location, where the replicas can access the same state/information

6. What are the services that a four-tier architecture provides in the first tier?
Load-balancing services
7. What does a reverse proxy do? When is it needed?
A reverse proxy allows a web server to provide content from another server without any intrusions or distractions. This is needed when providing vastly different web services from the same frontend.

8. Suppose you wanted to build a simple image-sharing web site. How would you design it if the site was intended to serve people in one region of the world? How would you then expand it to work globally?
  * One Region: Have one webserver located in that region and have the DNS resolve to that server.
  * Globally: Have multiple webserver replicas around the world, and use a GLB that responds to a DNS request for the website and provides the address of the closest replica.

9. What is a message bus architecture and how might one be used?
A MBA is a communication service between servers, that updates and distributes information among the different servers. It can be used to update information among different services, instead of constantly polling a database to see if new information has been added.

10. What is an SOA?
A group of large services that are self-contained and accessible via an API, and can communicate between services using API calls

11. Why are SOAs loosely coupled?
So services can easily be improved or replaced without disrupting other services

12. How would you design an email system as an SOA?
Separate each feature into its own service. So storage would be its own service, send/receive would be its own service, spam detection would be its own service, address book its own service, etc., so that all of them could be improved without vastly hindering the other services

13. Who was Christopher Alexander and what was his contribution to architecture?
His contribution was providing a simplified look at complex design issues through the usage of patterns.
