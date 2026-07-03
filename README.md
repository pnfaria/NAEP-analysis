# NAEP State Performance Dashboard

This repository contains an interactive dashboard developed in **R + Shiny** for analyzing the educational performance of US states based on data from the **NAEP (National Assessment of Educational Progress)**, analyzing student performance such as average scale scores, which provide a standardized method for summarizing overall achievement across different subjects and grade levels. The grades evaluated were 4th and 8th, covering the years 2003, 2019, 2022, and 2024.

The goal is to offer an accessible, transparent, and methodologically rigorous tool to support educators, researchers, and administrators in exploring educational indicators over time.

---

## 📊 Features

- Selection of **state**, **year**, and **grade** (4th and 8th grades)
- **Average Scale Scores**
- Comparison between states
- Interactive table (DT)
- Download of filtered data
- Responsive and intuitive interface

---

## 📄 Database used

- This dashboard uses exclusively public data made available by official United States agencies. Data can be accessed through the NAEP Data Service API, available at the NAEP Data Explorers homepage: https://www.nationsreportcard.gov/ndecore/xplore/NDE
- All data used is open, free, and publicly accessible, following the transparency guidelines of NCES and the Department of Education. No sensitive, private, or restricted information is used in this project.
- Results by state (jurisdiction), year, and grade
- Recent updates: 2003, 2019, 2022, and 2024.


---

## 🛠️ Technologies

- **R**
- **Shiny**
- **tidyverse**
- **httr / jsonlite**
- **DT**

---

## 📁 Repository structure
<img width="196" height="175" alt="Screenshot 2026-07-02 222800" src="https://github.com/user-attachments/assets/6465dd27-9a78-4fa1-9174-85d906180180" />


---

## 🚀 Access the dashboard

🔗 https://d7h8rk-priscila-neves.shinyapps.io/k12_dashboard

## How to run the app locally

1. Install the necessary packages
In the R console, run:

```r
install.packages(c("shiny", "tidyverse", "httr", "jsonlite", "DT"))
```

2. Download the ZIP file of this repository directly from GitHub.
3. Open the project in RStudio. Go to File → Open Project.
4. Select the NAEP-analysis folder and them k12-Dashboard folder.
5. Open the file inside it called app.R.
6. Click Run App.
The dashboard will open automatically in your browser.

---

## 📬 Contato

Priscila Neves Faria, Ph.D.  
Educator, Researcher and Data Scientist

LinkedIn: https://www.linkedin.com/in/priscila-neves-faria


---

