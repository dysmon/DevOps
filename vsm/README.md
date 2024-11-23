# Value Stream Mapping Analysis

This project involves analyzing the current development process using Value Stream Mapping (VSM) methodology. The main goal is to increase team productivity, reduce delays, and improve overall process efficiency.

## Task Map

[Open the Task Map on Google Drive](https://drive.google.com/file/d/1Kb0PbeDtTPhFPjvW1sVT5LFaaIhUGDVF/view?usp=drive_link)


## Current State Analysis

### **Key Data**
| Process         | Cycle Time (hours) | VAT (hours) | Rework (hours) | Quality Rate (%) | WIP |
|------------------|--------------------|-------------|----------------|------------------|-----|
| **Analysis**     | 16                 | 16          | 2              | 80%              | 1   |
| **System Design**| 40                 | 36          | 4              | 80%              | 2   |
| **Development**  | 120                | 96          | 12             | 65%              | 12  |
| **Testing**      | 50                 | 34          | 8              | 50%              | 5   |
| **Deployment**   | 20                 | 16          | 4              | 90%              | 1   |

---

### **Metrics**
1. **Total Lead Time (LT):**  
   - **260 hours VAT + 34 hours rework + 140 hours buffer = 434 hours**

2. **Process Efficiency:**  
   - **112 / 434 = 25.80%**

3. **Rework Analysis:**  
   - **Development:** 12 hours → Largest contributor to rework.  
   - **Testing:** 8 hours → Second highest rework.  

4. **Quality Rates:**  
   - Lowest in Testing (50%) and Development (65%).

5. **Waiting Time Calculation:**  
   - Waiting time = Cycle Time × (WIP - 1).  
   - **Development:** 120 × (12 - 1) = 1,320 hours.  
   - **Testing:** 50 × (5 - 1) = 200 hours.

6. **Throughput:**  
   - Adjusted throughput based on quality:  
     - **Development:** 0.83 tasks/week.  
     - **Testing:** 0.4 tasks/week.  

---

## Problems Identified
1. **High Rework:**  
   - Development and Testing stages require the most rework, leading to delays.
2. **Low Quality Rates:**  
   - Particularly in Testing (50%) and Development (65%).
3. **Excessive WIP:**  
   - Development has 12 tasks in progress, creating bottlenecks.
4. **Low Process Efficiency:**  
   - Only 25.80%, indicating significant waste in the process.
5. **Cycle Time Delays:**  
   - Long cycle times in Development (120 hours) and Testing (50 hours).

---

## Future State Proposal

### **Key Changes**
1. **Improve Quality Rates:**  
   - System Design: **80% → 90%**  
   - Development: **65% → 85%**  
   - Testing: **50% → 70%**

2. **Reduce WIP:**  
   - Development: **12 → 10**  
   - Testing: **5 → 3**

3. **Reallocate Resources:**  
   - Testing: Increase staff from 1 to 2 employees.  
   - Development: Reduce staff from 5 to 4 employees.

4. **Reduce Cycle Time:**  
   - Optimize Development and Testing processes to lower cycle times.

---

### **New Metrics**
1. **Total Lead Time (LT):**  
   - **224 hours VAT + 34 hours rework + 122 hours buffer = 380 hours**

2. **Process Efficiency:**  
   - **112 / 380 = 30%**

3. **Throughput Improvement:**  
   - **System Design:** 0.9 tasks/week.  
   - **Testing:** 0.6 tasks/week.  

---

## Recommendations
1. **Automate Testing:**  
   - Implement continuous testing to reduce manual errors and rework.
2. **Adopt Agile Practices:**  
   - Use Kanban to manage WIP and ensure smoother flow.
3. **Focus on Training:**  
   - Provide workshops to improve testing and development skills.
4. **Monitor and Iterate:**  
   - Regularly measure WIP, rework, and quality rates to track progress.

---

## Conclusion
By addressing the bottlenecks and inefficiencies in Development and Testing stages, the proposed future state achieves a higher process efficiency (30%) and reduces lead time to 380 hours. This aligns the DevOps team for better throughput and sustainable productivity.

---
