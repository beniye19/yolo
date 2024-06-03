Objectives and Reasoning
1. Choice of Kubernetes Objects for Deployment
Use of - or the lack of use - of StatefulSets for Storage Solutions
Reasoning:

Deployment: Deployments are used for stateless applications where each pod is interchangeable. This is ideal for web applications, APIs, and similar services that do not require persistent storage or unique identities.
StatefulSet: StatefulSets are utilized when you need stable, unique network identifiers, persistent storage, or ordered, graceful deployment and scaling. This is suitable for databases or any service that maintains state across restarts.
For applications requiring persistent data (like databases), we used StatefulSets to ensure each pod has a unique identifier and stable storage. For stateless applications, we used Deployments to manage the replicas.