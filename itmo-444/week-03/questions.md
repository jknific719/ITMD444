## Chapter 02 - Designing for Operations

1. Why is design for operations so important? It's important because designing
for operations is required to make sure all the operations function normally on
a regular basis for a given service

2. It's typically supported by a configuration file that allows to set the
parameters for the automated configuration. An API then uses this configuration
file to automatically configure states.

3. The important factors are updates to the master database, deciding if the
query should be handled by the master or read-only database, segregation of
queries, and not to rely on luck.

4. Our FOG servers. I would have a master server control both servers and
handle the proper requests for imaging, etc. based on what server will required
to be contacted.

5. The developers of the software/feature you're fixing or adding might not
like your code, as it might not adhere to their own standards, their vision
for the program, or the internal code structure. It also shows that they
don't need to care about adding features since eventually you'll just write them yourself

6. Problems that are easy to fix, yet have an high impact should be the
issues you tackle first, then hard, high priority problems, followed by easy,
low impact, and lastly, hard, low impact problems should be worked on last.

7. Write reports along with feature requests so that the vendor can see the use-case for the feature and how it would be implemented.
