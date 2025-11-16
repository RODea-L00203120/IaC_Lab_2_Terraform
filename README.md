# IaC_Lab_2_Terraform

Repository in support of academic report for Lab 2's prescribed topic.

This repository provides a means of Version Control and evidences the following:

The authors engagement in practitioner-based research in effort to compose a IaC solution for a hypothetical DevOps pipeline.

- The proposed scenario is the provision of infrastructure for the deployment of a feedback mechanism for employees in an organization.

- While the landing page is simplistic (a form), reliability, security, modularity and scalability are of concern and therefore the underlying architecture design aimed for is as follows:

## Infrastructure Architecture

```mermaid
graph TB
    subgraph Internet["Internet Layer"]
        User[User Browser]
        S3["S3 Bucket - Terraform State"]
    end
    
    subgraph VPC["AWS VPC 10.0.0.0/16"]
        IGW[Internet Gateway]
        ALB[Application Load Balancer]
        RDS[("RDS Multi-AZ<br/>PostgreSQL")]
        
        subgraph AZ1["Availability Zone 1"]
            subgraph PubSub1["Public Subnet 10.0.1.0/24"]
                NAT1[NAT Gateway]
            end
            subgraph PrivSub1["Private Subnet 10.0.10.0/24"]
                EKS1["EKS Worker Nodes<br/>Flask App"]
            end
        end
        
        subgraph AZ2["Availability Zone 2"]
            subgraph PubSub2["Public Subnet 10.0.2.0/24"]
                NAT2[NAT Gateway]
            end
            subgraph PrivSub2["Private Subnet 10.0.20.0/24"]
                EKS2["EKS Worker Nodes<br/>Flask App"]
            end
        end
    end
    
    User -->|HTTPS| IGW
    IGW --> ALB
    ALB --> EKS1
    ALB --> EKS2
    EKS1 --> RDS
    EKS2 --> RDS
    EKS1 -.->|Outbound| NAT1
    EKS2 -.->|Outbound| NAT2
    NAT1 --> IGW
    NAT2 --> IGW
    
    style Internet fill:#f0f0f0,stroke:#333,stroke-width:2px
    style VPC fill:#fff9e6,stroke:#333,stroke-width:3px
    style AZ1 fill:#e3f2fd,stroke:#1976d2,stroke-width:2px
    style AZ2 fill:#e8f5e9,stroke:#388e3c,stroke-width:2px
    style PubSub1 fill:#bbdefb,stroke:#1976d2
    style PubSub2 fill:#c8e6c9,stroke:#388e3c
    style PrivSub1 fill:#90caf9,stroke:#1976d2
    style PrivSub2 fill:#a5d6a7,stroke:#388e3c
    style ALB fill:#ff9800,stroke:#333,stroke-width:2px
    style RDS fill:#9c27b0,stroke:#333,stroke-width:2px,color:#fff
    style S3 fill:#4caf50,stroke:#333,stroke-width:2px
```

## Early Design decisions

- Create a dev container for version locking, portability and maintainability.

- Use terraform locally through the CLI, avoid vendor locked cloud implementation and instead store state configuration files on a private S3 bucket. Less provider dependence, similar security, greater flexibility and portability.

- Modular design for: VPC, ALB, EKS clusters, RDS & Security Group configuration

- Simple Python Flask App - Hello world to begin, then form submission to DB

- Aiming to implement multi-cluster cluster approach however:

1. Get EC2 instances working with correctly configured VPC, ALB, Security, RDS in own branch.

2. Branch off  above to work on single-cluster EKS implementation

3. Branch off above to work on multi-cluster implementation

4. Merge most successful to main

# State Tracking

While of less concern as a solo developer, best practice indicates a method of tracking the state of terraform IaC changes is required when working with others to avoid conflicts, corruptions, race conditions etc. 
Rather than rely on cloud tooling (Terraform HCP) to track state changes the author investigated alternatives and encountered the concept of provisioning a private, encrypted S3 bucket to store an organizations `terraform.tfstate` file. A script file is included which runs through this process. Below are evidence of this working: 

![](screenshots/2025-11-16-15-05-21.png)

![](screenshots/2025-11-16-12-43-04.png)

## Stage 1: Simple Infrastructure set-up

The author intended modularity to be a core design element for this lab and incrementally developed the application.

A branch was created to implement two EC2 instances on public networks, from there the following could be implemented:

- A VPC module, configurable via the terraform/variables.tf file which pass to:
    terraform/modules/vpc/main.tf         ← VPC module receives them
