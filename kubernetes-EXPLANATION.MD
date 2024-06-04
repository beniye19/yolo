# Explanation.md

## Objectives and Reasoning

### 1. Choice of Kubernetes Objects for Deployment
#### Use of - or the lack of use - of StatefulSets for Storage Solutions

**Reasoning:**
- **Deployment:** Deployments are used for stateless applications where each pod is interchangeable. This is ideal for web applications, APIs, and similar services that do not require persistent storage or unique identities.
- **StatefulSet:** StatefulSets are utilized when you need stable, unique network identifiers, persistent storage, or ordered, graceful deployment and scaling. This is suitable for databases or any service that maintains state across restarts.

For applications requiring persistent data (like databases), I used StatefulSets to ensure each pod has a unique identifier and stable storage. For stateless applications, I used Deployments to manage the replicas.

### 2. Method Used to Expose Pods to Internet Traffic

**Reasoning:**
- **Service Types:**
  - **ClusterIP:** Exposes the service on a cluster-internal IP. This is the default type and is suitable for internal-only services.
  - **NodePort:** Exposes the service on each Node's IP at a static port. This makes the service accessible from outside the cluster by requesting `<NodeIP>:<NodePort>`.
  - **LoadBalancer:** Exposes the service externally using Google Cloud's load balancer. This is ideal for production environments in GKE (Google Kubernetes Engine).

For exposing the application to the internet on GKE, I typically use LoadBalancer services. This approach leverages Google Cloud's built-in load balancer to provide a stable endpoint for external access. In cases where using a cloud provider's load balancer is not feasible, NodePort can be used as an alternative.

### 3. Use of or Lack of Persistent Storage

**Reasoning:**
- **Persistent Volume (PV) and Persistent Volume Claim (PVC):** PVs and PVCs are used to manage persistent storage in Kubernetes. PVs are storage resources in the cluster, and PVCs are requests for those resources.
- **GKE Specific:** On GKE, I use Google Persistent Disks as the backend for our PVs. This ensures high availability and durability of the data.

Persistent storage is crucial for stateful applications that need to retain data across pod restarts and rescheduling. For databases and similar applications, I created PVs and PVCs backed by Google Persistent Disks to ensure data persistence. For stateless applications, I did not configure persistent storage since their data does not need to persist beyond the lifecycle of a pod.

### 4. Git Workflow Used to Achieve the Task

**Reasoning:**
- **Forking Workflow:** In this workflow, developers fork the main repository to create their copies where they can make changes without affecting the original codebase.
  - **Fork:** Each developer creates a fork of the main repository to their GitHub account.
  - **Clone:** Developers clone the fork to their local machine for development.
  - **Feature Branches:** Develop new features or bug fixes in separate branches within the forked repository.
  - **Pull Requests:** Once the changes are complete and tested, developers create a pull request to merge the changes back into the main repository.

This workflow allows multiple developers to work independently without interfering with each other's work, enabling easy collaboration through pull requests and code reviews.

### 5. Successful Running of Applications from the Link Provided in the GitHub Repository's README.md

**Reasoning:**
- **Validation:** After deployment, I verified the application by accessing the provided URL to ensure it was running correctly.
- **Debugging Measures:** If the application did not run successfully, I used several debugging measures:
  - **Logs:** Checking the logs of the pods using `kubectl logs` to identify errors.
  - **Describe Pods:** Using `kubectl describe pods` to get detailed information about the pod's state.
  - **Events:** Monitoring cluster events with `kubectl get events` to detect issues during the deployment process.
  - **Port-Forwarding:** Using `kubectl port-forward` to access the application locally and diagnose issues without exposing it to the internet.

### 6. Good Practices
#### Docker Image Tag Naming Standards

**Reasoning:**
- **Tagging:** I followed a consistent tagging strategy to identify Docker images easily. Tags include:
  - **Semantic Versioning:** Tags like `v1.0.0`, `v1.1.0`, etc., to indicate versions.
  - **Environment-Specific Tags:** Tags like `latest`, `staging`, `production` to denote different deployment stages.
  - **Commit Hashes:** Including short commit hashes in tags for traceability, e.g., `v1.0.0-abc123`.

This practice helps in managing and deploying the correct versions of images across different environments, ensuring that each deployment uses the intended version of the image.

#### Personalization of Images and Containers

**Reasoning:**
- **Custom Labels and Annotations:** Adding metadata like labels and annotations to Docker images and Kubernetes objects for easy identification and management.
- **Descriptive Names:** Using descriptive names for images and containers to indicate their purpose and version clearly.

This approach enhances maintainability and simplifies the management of multiple images and containers across various stages of the deployment pipeline.

### Application Access

- **Frontend**: Visit [http://34.138.116.228:8080](http://34.138.116.228:8080) in your web browser.
- **Backend**: Access [http://34.23.67.236:5000](http://34.23.67.236:5000) to interact with your backend services.

These URLs are intended for accessing the frontend and backend of my application. 

Please note that the live URLs are not currently accessible. This could be due to several factors, including misconfiguration of services, firewall rules blocking external access, or issues with network connectivity. Further troubleshooting is needed to determine the exact cause and resolve the issue.


### Ensuring Data Persistence with Persistent Volumes

The use of persistent volumes was achieved by defining a `PersistentVolume` (PV) and a `PersistentVolumeClaim` (PVC) in the Kubernetes configuration. The MongoDB deployment was then configured to mount this persistent storage at the `/data/db` path. This setup ensures that data stored in the MongoDB database is retained on the persistent volume, even if the MongoDB pod is deleted and recreated, thus preventing the loss of items added to the cart.
