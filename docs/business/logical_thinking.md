# Logic Tree

There are two types of logic trees: diagnostic ones and solution ones.

## Diagnostic Tree

Diagnostic trees break down a "why" key question, identifying all the
possible root causes for the problem.

```mermaid
flowchart TB
  prob["Problem"]
  cause1["Cause1"]
  cause2["Cause2"]
  cause3["Cause3"]
  cause1-1["Cause1-1"]
  cause1-2["Cause1-2"]
  cause3-1["Cause3-1"]
  prob -- Why --> cause1
  prob -- Why --> cause2
  prob -- Why --> cause3
  cause1 -- Why --> cause1-1
  cause1 -- Why --> cause1-2
  cause3 -- Why --> cause3-1
```

## Solution Tree

Solution trees break down a "how" key question, identifying all the
possible alternatives to fix the problem.

```mermaid
flowchart TB
  prob["Problem"]
  soln1["Solution1"]
  soln2["Solution2"]
  soln3["Solution3"]
  soln1-1["Solution1-1"]
  soln1-2["Solution1-2"]
  soln3-1["Solution3-1"]
  prob -- How --> soln1
  prob -- How --> soln2
  prob -- How --> soln3
  soln1 -- How --> soln1-1
  soln1 -- How --> soln1-2
  soln3 -- How --> soln3-1
```

# Pyramid Structure

Your thinking should form a pyramid structure that cascades down from a
single, top-level thought. Below that top-level thought sit your
arguments, and below your arguments sit your supporting data.

Pyramid structure can be used for the purpose of organizing your
arguments and testing the validity of your claims.

```mermaid
flowchart BT
  ans["
    Issue
    <hr>Key Message: The Answer to the Issue
  "]
  arg1["
    Question1 for the Issue
    <hr>Argument1
  "]
  arg2["
    Question2 for the Issue
    <hr>Argument2
  "]
  arg3["
    Question3 for the Issue
    <hr>Argument3
  "]
  evd1-1["Data/Fact1-1"]
  evd1-2["Data/Fact1-2"]
  evd3-1["Data/Fact3-1"]
  arg1 -- So What --> ans
  arg2 -- So What --> ans
  arg3 -- So What --> ans
  evd1-1 -- So What --> arg1
  evd1-2 -- So What --> arg1
  evd3-1 -- So What --> arg3
```

## How to Construct Pyramid Structure

### 1. Define the issue and answer to it

The issue and the answer to it should be defined first.

Communicate your answer, conclusion or recommendation immediately, not
at the end.

When you construct pyramid structure for communication like negotiation,
it is better to define the issue from the listener point of view.

### 2. List the questions that need to be clarified to answer the issue

Business framework is a good reference for listing good questions.

### 3. Group and sequence your arguments

Group similar insights into the same argument and be thoughtful about
how to sequence your arguments.

### 4. Support your arguments with data

Ensure that you have data that supports every argument and prevents your
reader from disputing them.

## How to validate a written document

Here is the steps to validate a written document.

### 1. Is the issue defined and consistently cared?

### 2. Are the questions for the issue appropriate?

### 3. Is evidence for each argument enough?

### 4. Are the negative aspects also being mentioned?

### 5. Adequately prepared for counterarguments?

### 6. Easy to read from logical and visual perspective?

Following CREC (Conclusion -> Reason -> Evidence/Example -> Conclusion)
is the one of the option to make a text easy to understand.
