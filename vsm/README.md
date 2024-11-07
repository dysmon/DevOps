# Value Stream Mapping Analysis

This project involves analyzing the current development process using Value Stream Mapping (VSM) methodology. The main goal is to increase team productivity, reduce delays, and improve overall process efficiency.

## Task Map

[Open the Task Map on Google Drive](https://drive.google.com/file/d/1Kb0PbeDtTPhFPjvW1sVT5LFaaIhUGDVF/view?usp=sharing)

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

## Key Findings

1. **High Rework Times**: Rework consumes a significant portion of time at each stage, especially in Development (12 hours) and Testing (8 hours).
2. **Low Quality Rates**: Stages like Testing (50%) and Development (65%) have low pass-through rates, causing bottlenecks and further rework.
3. **Overloaded Stages**: Development, with 5 employees, requires the longest time and has a substantial rework component, creating delays.

## Proposed Improvements (Future State)

To achieve the goal of completing 10 tasks per week, the following strategies are suggested:

1. **Reduce Rework by Improving Quality at Each Stage**:
   - Implement automated testing to reduce manual errors.
   - Establish clearer requirements and design reviews to reduce misunderstandings in Development.

2. **Streamline Process Flow and Reduce Waiting Times**:
   - Parallelize tasks where possible to minimize delays between stages.

3. **Optimize Resource Allocation**:
   - Adjust employee assignments to alleviate bottlenecks, particularly at the Development and Testing stages.

4. **Implement Continuous Improvement Practices**:
   - Hold regular retrospectives to analyze rework causes and address inefficiencies iteratively.

### Target Metrics

- **Cycle Time per Task**: Aim to reduce from 260 hours to approximately 36 hours per task to meet the weekly target of 10 tasks.
- **Rework Reduction**: Reduce rework by at least 50%, potentially saving up to 17 hours per task.
  
## Calculations

To meet the goal of 10 tasks per week:
- **Total Weekly Hours Available**: 9 developers * 40 hours = 360 hours
- **Target Cycle Time per Task**: 360 hours / 10 tasks = 36 hours

## Future Enhancements

- Automate data collection for each process stage to track ongoing improvements.
- Continue to adjust resources based on process bottlenecks.
- Develop dashboards to visualize cycle time, rework, and VAT metrics in real-time.