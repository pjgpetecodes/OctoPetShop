# OctoPetShop
Octopus Pet Shop Example Web app written in .NET Core.  This solution consists of:
 - Octopus Pet Shop Web front end
 - Product Service
 - Shopping Cart Service
 - Database project using Dbup

 Included in this example are docker files to make each component as a container.  The docker-compose file at the root of the project also includes a SQL Server image so the entire application can be run in containers.  

 Kubernetes .yaml files have been included in this project which will pull the images from the octopussamples Docker Hub repo.

# Important Notes
- Password for SQL Server will need to be changed, current password will fail due to password requirements.  You will also need to update the password in octopetshop-sql-deployment.yaml, octopetshop-database-job.yaml, octopetshop-productservice-deployment.yaml, and octopetshop-shoppingcartservice-deployment.yaml.
- SQL Server image has not been configured with a persistent volume claim, you will lose your data if you re-create your Kubernetes cluster.
- When using Octopus Deploy to deploy the .yaml files to a Kubernetes cluster, be sure that the octopetshop-database-job.yaml is run AFTER both octopetshop-sqlserver-cluster-ip-service.yaml and octopetshop-sql-deployment.yaml.
- When debugging in Visual Studio 2022 without Docker Compose;

    - Install SQL Server 2019 upwards.
    - Create a database named OctoPetShop
    - Add the connection string for the database to the OctopusSamples.OctoPetShop.Database Project;
        - Right click on the `Database` Project
        - Click Properties
        - Select the `Debug` > `General` tab from the menu on the left
        - Click the `Open debug launch profiles UI` link.
        - Enter a connection string in the following format, remembering to escape the `=` characters;

```
dbUpConnectionString=Data Source/=.\SQLEXPRESS;Integrated Security/=True;Connect Timeout/=30;Encrypt/=False;TrustServerCertificate/=False;ApplicationIntent/=ReadWrite;MultiSubnetFailover/=False;Database/=OctoPetShop
```

- To debug using Docker direct from VS2022;
    - Install Docker Desktop
    - Select "docker-compose" from the "Startup Projects dropdown"
    - Run the project

- To provision to a local Kubernetes Cluster;
    - Install Docker Desktop
    - Enable Kubernetes in Docker Desktop
    - Build the Docker Images from the solution root directory with `BuildDockerImages.ps1 <domain>`
    - Push the Docker images to DockerHub with `PushToDockerHub.ps1 <domain>`
    - To test that the Docker images function correctly, you can use `RunDockerImages.ps1 <domain>`
    - To create a Kubernetes Cluster using a LoadBalancer;
        - Run `kubectl apply -f k8s` and access at http://localhost:5000
    - To create a Kubernetes Cluster using an Ingress Service;
        - Install Helm with `choco install kubernetes-helm`
        - Install the Helm Ingress Controller with `helm upgrade --install ingress-nginx ingress-nginx  --repo https://kubernetes.github.io/ingress-nginx  --namespace ingress-nginx --create-namespace`
        - Run `kubectl apply -f k8s-ingress` and access at http://localhost

