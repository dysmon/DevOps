# Value Stream Mapping Analysis

This project involves analyzing the current development process using Value Stream Mapping (VSM) methodology. The main goal is to increase team productivity, reduce delays, and improve overall process efficiency.

## Task Map

[Open the Task Map on Google Drive](https://drive.google.com/file/d/1Kb0PbeDtTPhFPjvW1sVT5LFaaIhUGDVF/view?usp=drive_link)

## Project Context

You are a manager of a development team with 9 developers. The team has struggled to complete tasks on time, and upper management has expressed dissatisfaction with consistent delays. This analysis aims to find the root causes of inefficiencies and propose actionable steps to optimize the process.

## Goals

- **Identify non-value-added activities (NVAT)**: Focus on reducing waiting times and rework to increase efficiency.
- **Optimize Value-Added Time (VAT)**: Streamline the process to increase the percentage of time spent on productive, value-adding activities.
- **Meet the weekly target of 10 tasks**: Adjust the cycle time to achieve the target of completing 10 tasks per week.

## Current State Analysis

### Data Overview

The following data describes the current cycle time, value-added time (VAT), rework, quality rate, and work-in-progress (WIP) at each process stage:

| Stage            | Cycle Time (hours) | VAT (hours) | Rework (hours) | Employees | Quality Rate |
|------------------|--------------------|-------------|----------------|-----------|--------------|
| Analysis         | 30                 | 16          | 4              | 1         | 85%          |
| System Design    | 40                 | 20          | 6              | 1         | 80%          |
| Development      | 120                | 36          | 12             | 5         | 65%          |
| Testing          | 50                 | 24          | 8              | 1         | 50%          |
| Deployment       | 20                 | 16          | 4              | 1         | 90%          |

### Total Cycle Time Without Rework: 260 hours  
### Total Lead Time: 434 hours  
### Total Rework Time: 34 hours  

## Current State

### **Key Data**
- **Processes:** Analysis, System Design, Development, Testing, Deployment
- **Problems:**
  - **High rework rates:** Development (12 hours), Testing (8 hours)
  - **Low quality rates:** Testing (50%), Development (65%)
  - **High Work-in-Progress (WIP):** Development (12 tasks), Testing (5 tasks)
  - **Cycle Time:**
    - Longest in Development (120 hours) and Testing (50 hours)

### **Metrics**
- **Total Lead Time (LT):** 400 hours (260 hours VAT + 34 hours rework + 140 hours buffer time)
- **Process Efficiency:** 25.80%

### **Identified Issues**
1. **Rework Problems:**
   - Testing and Development stages have the highest rework rates, causing delays.
2. **Resource Allocation:**
   - Development is overloaded (12 WIP) while other stages are underutilized.
3. **Low Output Quality:**
   - Testing and Development stages require significant quality improvements.
4. **Waiting Times:**
   - Excessive WIP leads to bottlenecks in Development and Testing.
5. **Throughput:**
   - Adjusted throughput is 0.8 tasks/week due to low quality and rework in key stages.

---

## Future State

### **Proposed Improvements**
1. **Increase Quality Rates:**
   - Improve QR in:
     - **System Design:** 80% → 90%
     - **Development:** 65% → 85%
     - **Testing:** 50% → 70%
2. **Reallocate Resources:**
   - Reduce the number of employees in Development from 5 to 4.
   - Increase the number of employees in Testing from 1 to 2.
3. **Reduce WIP:**
   - **Development:** Decrease WIP from 12 to 10.
   - **Testing:** Decrease WIP from 5 to 3.
4. **Reduce Cycle Time:**
   - Streamline processes in Development and Testing stages.
   - Expected cycle time reduction of 20%.

### **Metrics After Changes**
- **New Total Lead Time:** 224 hours + 34 hours rework + 122 hours buffer = 380 hours
- **Process Efficiency:** 30% (+4.2%)
- **Throughput:** 0.9 tasks/week.

---

## Recommendations

1. **Improve Quality at Each Stage**
   - Invest in training for developers and testers.
   - Standardize processes and implement automated testing tools.
2. **Optimize Resource Allocation**
   - Allocate additional resources to the Testing stage to reduce bottlenecks.
   - Adjust Development capacity to align with actual demand.
3. **Streamline Workflows**
   - Implement Agile practices, such as Kanban or Scrum, to reduce WIP and waiting times.
   - Use CI/CD pipelines for continuous testing and deployment.
4. **Automate Repetitive Tasks**
   - Introduce automation for testing and deployment to reduce errors and improve efficiency.
5. **Monitor Progress**
   - Regularly measure quality rates, rework, and lead time to ensure sustainable improvements.

---

## Conclusion

The proposed future state VSM significantly improves team efficiency and reduces delays. Implementing these improvements will help achieve sustainable productivity and meet business expectations.

---
