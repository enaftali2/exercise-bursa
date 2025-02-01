# Exercise Bursa Repository

## 1. Jenkins CI/CD Pipeline

This repository contains a `Jenkinsfile` that automates the build and packing of a Java application. It builds the Java artifact using Maven and pushes it to a repository.

### Jenkins Pipeline

- Defines the CI/CD pipeline.
- Maven configuration file for building the Java application.
- Simple Java application.

## 2. Ansible Playbook for Docker Compose Deployment

The repository includes an Ansible playbook that sets up and runs a simple Flask application with Redis. The Redis instance tracks the number of visitors to the web page.

### Deployment Files

- Ansible playbook for deploying the application.

### Running the Playbook

```sh
ansible-playbook -i inventory deploy_app.yml
```

## 3. Bash Script for Extracting Files

The repository includes a Bash script that can unpack multiple packed files, automating the extraction process.

### Script

- Shell script for extracting compressed files.

### Usage

```sh
./extract.sh file1.tar.gz file2.zip
```
