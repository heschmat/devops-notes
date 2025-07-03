# Understanding AWS Load Balancers and Their Use in Kubernetes

This document explains the different types of AWS Load Balancers, their purposes, and how they integrate with Kubernetes services and ingress controllers.

---

## AWS Load Balancers Overview

AWS offers three main types of load balancers under the umbrella service called **Elastic Load Balancer (ELB)**:

| Load Balancer Type       | OSI Model Layer | Description                                                                 | Typical Use Cases                               |
|-------------------------|-----------------|-----------------------------------------------------------------------------|------------------------------------------------|
| **Classic Load Balancer (CLB)** | Layer 4 & 7      | Older generation ELB supporting basic TCP/HTTP load balancing.              | Legacy apps, simple load balancing needs.      |
| **Network Load Balancer (NLB)** | Layer 4 (Transport) | High performance, ultra-low latency, TCP/UDP load balancing at network layer. | Real-time apps, IoT, static IPs, gaming, TLS passthrough. |
| **Application Load Balancer (ALB)** | Layer 7 (Application) | Advanced HTTP/HTTPS load balancing with host/path-based routing and WebSocket support. | Modern web apps, microservices, advanced routing. |

### What is Elastic Load Balancer (ELB)?

**ELB** is the overall AWS service that provides load balancing solutions — encompassing CLB, NLB, and ALB.

---

## Connecting AWS Load Balancers to Kubernetes

When running Kubernetes on AWS (e.g., with EKS), load balancers are provisioned to expose your services externally.

### Service Type: LoadBalancer

- Kubernetes Service of type `LoadBalancer` triggers the creation of an AWS ELB to expose the service externally.
- By default, this creates a **Classic Load Balancer (CLB)** on AWS.
- You can customize the load balancer type using **service annotations**.

### Customizing Load Balancer Type in Kubernetes

| Annotation                                              | Resulting Load Balancer           |
|---------------------------------------------------------|---------------------------------|
| None (default)                                          | Classic Load Balancer (CLB)      |
| `service.beta.kubernetes.io/aws-load-balancer-type: "nlb"` | Network Load Balancer (NLB)      |

---

## Ingress Controllers and Load Balancers

### NGINX Ingress Controller

- Runs as pods inside the cluster and manages HTTP/S ingress traffic.
- Exposed externally via a Kubernetes Service of type `LoadBalancer`.
- By default, this creates a **Classic Load Balancer (CLB)** unless annotated for NLB.
- Does **not** create an Application Load Balancer (ALB).

### AWS Load Balancer Controller

- A special controller to manage AWS Application Load Balancers (ALB) based on Kubernetes Ingress resources.
- Enables advanced routing features like host/path-based routing.
- ALBs are provisioned **only** via this controller and ingress resources, not through standard `LoadBalancer` Services.

---

## Summary

- **ELB** = AWS’s overall load balancing service family.
- **CLB** = Default load balancer for Kubernetes `LoadBalancer` Services on AWS.
- **NLB** = High-performance TCP/UDP load balancer, configurable via annotations.
- **ALB** = Advanced HTTP/HTTPS load balancer created and managed via AWS Load Balancer Controller and Kubernetes Ingress.
- **NGINX Ingress** uses Kubernetes Services for exposure and typically relies on CLB or NLB.

---

