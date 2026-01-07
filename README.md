# Enterprise Resource Management Portal (Ubuntu Edition)

---

## 🚀 Overview

A high-performance, full-stack enterprise web application designed to handle complex administrative workflows on **Linux environments**.  
This system features a **decoupled reporting service**, **dynamic task scheduling**, and **legacy system integration**, serving as a robust platform for employee management, reporting, and bulk data processing.

The project demonstrates advanced backend engineering concepts, including:

- **Java ProcessBuilder** for orchestrating external Node.js scripts  
- **Spring Dynamic Scheduling** for runtime-configurable background tasks  
- **Direct Web Remoting (DWR)** for low-latency client–server communication  

---

## 🏗 System Architecture

The application is built on a **Spring Framework–based backend** with a hybrid frontend architecture using **ExtJS** for dynamic grids and **JSP/HTML** for standard interfaces.

### Key Modules

- **Decoupled PDF Service (Puppeteer)**  
  Java `ProcessBuilder` triggers an isolated Node.js (Puppeteer) environment.  
  On Ubuntu, this utilizes a headless Chromium instance to render pixel-perfect PDF reports from HTML data without blocking the main JVM thread.

- **Dynamic Scheduler Service**  
  Leverages Spring’s `ThreadPoolTaskScheduler`. Unlike static `@Scheduled` tasks, this module allows runtime reconfiguration of cron expressions via the UI without restarting the application.

- **Bulk Data Engine**  
  Optimized Excel parsing module using **Apache POI** to handle large-scale data ingestion and export.

- **High-Speed AJAX Layer**  
  Utilizes **DWR (Direct Web Remoting)** to expose Java service methods directly to JavaScript, achieving sub-200ms latency for dynamic UI components.

---

## 🛠 Tech Stack

### Backend
- **Java 11**
- **Spring Framework 5.x** (MVC, DI, Scheduling)
- **Hibernate 5.x** (ORM & Database Abstraction)
- **Apache POI** (Excel Processing)
- **DWR 3.x** (AJAX Remoting)

### Frontend
- **ExtJS 4.2** (Advanced Data Grids & UI Components)
- **HTML5 / CSS3 / JSP** (UI Layer)

### Infrastructure & Tools
- **Ubuntu 22.04 / 24.04 LTS** (Host OS)
- **Node.js & Puppeteer** (Headless Browser for PDF Generation)
- **MySQL 5.x** (Relational Database)
- **Maven** (Build Management)

---

## ✨ Key Features & Tabs

1. **Dynamic Dropdowns**  
   Hybrid HTML/ExtJS selection tools with real-time data binding.

2. **Modal Popups**  
   Context-aware popup editors for modifying complex entity relationships.

3. **Advanced Grids**  
   Searchable, paginated data tables with server-side sorting.

4. **DWR Entry Screen**  
   Fast data entry forms leveraging DWR for instant validation.

5. **Excel Processor**  
   Bulk upload/download facility capable of parsing complex spreadsheets.

6. **Web Services**  
   RESTful API endpoints for external system integration.

7. **PDF Reporting Engine**  
   Orchestrates headless Chrome via Node.js on Ubuntu to stream binary PDF data back to the client.

8. **Dynamic Cron Manager**  
   Real-time dashboard to monitor and hot-swap cron expressions for background tasks at runtime.

---

## ⚙️ Ubuntu Installation & Setup

### 1. Prerequisites

```bash
sudo apt update
sudo apt install -y openjdk-11-jdk maven nodejs npm mysql-server
```

---

## 2. Database Configuration

Create the database in MySQL:

```sql
CREATE DATABASE mednet_db;
```

Configure `src/main/resources/application.properties`:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/mednet_db?useSSL=false
spring.datasource.username=root
spring.datasource.password=your_password
```

---

## 3. Puppeteer Environment Setup (Linux)

Unlike Windows, Ubuntu requires specific shared libraries to run Headless Chrome.

```bash
# Create directory
mkdir -p /home/ubuntu/mednet_puppeteer
cd /home/ubuntu/mednet_puppeteer

# Install Puppeteer and Chrome binary
npm install puppeteer
npx puppeteer browsers install chrome

# Install Linux dependencies for Chromium
sudo apt install -y \
  libnss3 \
  libatk-bridge2.0-0 \
  libcups2 \
  libdrm2 \
  libxkbcommon0 \
  libxcomposite1 \
  libxdamage1 \
  libxrandr2 \
  libgbm1 \
  libasound2
```

---

## 4. Application Properties Update

Ensure all paths are configured for the Ubuntu file system:

```properties
puppeteer.script.dir=/home/ubuntu/mednet_puppeteer
puppeteer.node.path=/usr/bin/node
puppeteer.script.name=generate.js
```

---

## 5. Build & Deployment

```bash
mvn clean install
mvn jetty:run
# OR if using Spring Boot:
mvn spring-boot:run
```

---

## 👨‍💻 Author

**Devansh Prakash Dhopte**  
LinkedIn: Devansh Dhopte  
Email: devanshdhopte@gmail.com  

Developed as a capstone project demonstrating **full-stack enterprise capabilities** and **Linux systems integration**.
