Objectives and Reasoning
1. Choice of Kubernetes Objects for Deployment
Use of - or the lack of use - of StatefulSets for Storage Solutions
Reasoning:

Deployment: Deployments are used for stateless applications where each pod is interchangeable. This is ideal for web applications, APIs, and similar services that do not require persistent storage or unique identities.
StatefulSet: StatefulSets are utilized when you need stable, unique network identifiers, persistent storage, or ordered, graceful deployment and scaling. This is suitable for databases or any service that maintains state across restarts.
For applications requiring persistent data (like databases), we used StatefulSets to ensure each pod has a unique identifier and stable storage. For stateless applications, we used Deployments to manage the replicas.

2. Method Used to Expose Pods to Internet Traffic
Reasoning:

Service Types:
ClusterIP: Exposes the service on a cluster-internal IP. This is the default type and is suitable for internal-only services.
NodePort: Exposes the service on each Node's IP at a static port. This makes the service accessible from outside the cluster by requesting <NodeIP>:<NodePort>.
LoadBalancer: Exposes the service externally using Google Cloud's load balancer. This is ideal for production environments in GKE (Google Kubernetes Engine).
For exposing the application to the internet on GKE, we typically use LoadBalancer services. This approach leverages Google Cloud's built-in load balancer to provide a stable endpoint for external access. In cases where using a cloud provider's load balancer is not feasible, NodePort can be used as an alternative.

3. Use of or Lack of Persistent Storage
Reasoning: