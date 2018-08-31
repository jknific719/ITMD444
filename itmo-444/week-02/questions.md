1. A setup of computers or other computing machines that host services and applications, rather than just one machine hosting the service or application

2. Load balancer with backends: evenly distributes traffic to different servers that appear to the user as identical, but some could be higher end than other. Health checks are also used to make sure that the backends are operating properly.  
Server with multiple backends: A frontend server that relays different parts of a request as queries to different backend servers that will reply with one final response to the query.  
Server tree: One main root server takes the query and forwards it to its parent servers, which then search the servers under it.

3. Storing state in one machine, storing state in shards across numerous machines, and state being stored and updated using data in a cache

4. The benefits are speed, and the fact that the master server isn't backed up with the amount of data it needs to process

5. The uploader would use the master server to determine where the data should be stored, then the uploader would directly contact the machines where that data would be stored.

6. A distributed system can only have two of three attributes at a given time: Consistency, Availability, and Partition Tolerance. A system cannot have all three at the same time, due to limitations of systems.

7. A system is loosely coupled when you can replace parts of a system that perform the same basic task as the part you're replacing yet it being different physically and the system still functions. This has the benefit of allowing replacement systems that aren't exactly the same as the initial system, but can still perform the same task to be used.

8. A tightly coupled system is like mapquest, which especially in its early days, simply would search for a place that matched or was similar to your query, where a loosely coupled system like Google Maps, was able to take the same query as mapquest, but over time was able to evolve in the background, using different methods of searching, yet still taking the same input.

9. First you calculate how much time it will take the signal to travel at the speed of light. Then you factor in the other variables such as authentication, formatting, etc, and then finally the amount of time it takes the message to be read from storage.

10. In Section 1.7 three design ideas are presented for how to process email deletion requests. Estimate how long the request will take for deleting an email message for each of the three designs. First outline the steps each would take, then break each one into individual operations until estimates can be created.  
1st design: The client would need to send the signal to the server, which would take time depending on distance, then the server would need to take time to query the index, mark it for deletion, and delete the message from storage.  
2nd design: The client would need to contact the server, and tell the index to mark the email for deletion, but then you would need a routine that runs at a certain time and/or periodically to search the storage and delete the emails listed for deletion, which could take more time due to deleting in batches.  
3rd design: The client would need to tell the server to delete the email, but also to tell the client that it is ready to receive more input, while also taking the time to search for the email in storage and delete the email.
