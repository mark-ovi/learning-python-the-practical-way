---
title: "Part 3, Chapter 5: Running Tasks Automatically"
summary: >
  Turn manual workspace tasks into recurring automation with while loops,
  time.sleep(), scheduling, and procedural task orchestration.
difficulty: "beginner"
estimated_time: "60 min"
---
<!-- markdownlint-configure-file {"MD025": {"front_matter_title": ""}} -->

# Part 3, Chapter 5: Running Tasks Automatically

In Chapter 3.4, the Workspace Automation Engine learned how to behave
reliably when individual operations fail.

The next problem is operational.

Someone still has to start the program.

A useful automation should be able to run on its own. It might update the
Workspace Index every 30 minutes, generate a report, and make a backup every
time the pipeline runs.

This chapter introduces a scheduler and turns the project into a
long-running process.

The chapter uses the third-party schedule package. Part 2 already introduced
third-party packages through BeautifulSoup, so the package itself is not a
new kind of Python idea.

The design remains procedural. automation_engine.py coordinates existing task
functions, while scheduler.py handles recurring execution. Classes, type
annotations, and the formal AutomationEngine abstraction are deferred to
Chapter 3.7.

## What You Will Build

The final project will contain:

    3-5-workspace-automation-engine/
    ├── main.py
    ├── automation_engine.py
    ├── scheduler.py
    ├── logging_utils.py
    ├── tasks/
    │   ├── __init__.py
    │   ├── index_task.py
    │   ├── csv_reporter.py
    │   └── backup_task.py
    ├── workspace/
    ├── backups/
    ├── reports/
    ├── logs/
    └── workspace_index.json

The automation pipeline will run in this order:

    Workspace
        ↓
    Update Workspace Index
        ↓
    Generate CSV Report
        ↓
    Back Up Workspace

The scheduler then decides when that pipeline runs.

## Learning Goals

You will learn how to:

- use a while loop for a long-running process;
- use time.sleep() to control a polling loop;
- schedule recurring functions with schedule;
- distinguish scheduling from task orchestration;
- coordinate multiple task functions in a predictable order;
- introduce a procedural automation_engine.py;
- prevent duplicate schedule registration;
- handle KeyboardInterrupt for graceful shutdown;
- test scheduling without waiting for real time to pass.

## New Concepts

This chapter introduces:

- while loops;
- time.sleep();
- the schedule package;
- recurring jobs;
- procedural task orchestration;
- scheduler registration;
- graceful shutdown with KeyboardInterrupt.

## Reused Concepts

You already know:

- for loops;
- conditionals;
- functions and return values;
- exceptions;
- logging;
- modules;
- third-party package installation;
- filesystem operations;
- dictionaries and JSON;
- the Workspace Index.

The important progression is that the program is now responsible for staying
alive and deciding when work should happen.

---

## 1. Why Scheduling Changes the Application

A manual program often looks like this:

    python main.py

The person starts it, the task runs, and the process exits.

That is appropriate for a one-time command.

Automation is different. You might want a report to be refreshed regularly
without remembering to start the program.

A scheduler answers a simple question:

> When should this function run?

The scheduler does not need to know what the function does.

For example:

    def create_report():
        print("Report generated.")

The scheduler can treat create_report as a job without knowing anything about
reports.

This separation is important:

- a task knows how to perform work;
- the automation engine knows which tasks belong together;
- the scheduler knows when the automation should run.

---

## 2. Keeping a Process Alive With while

A scheduler needs a process that remains alive long enough to check for
scheduled work.

A while loop repeats a block while its condition is true:

    count = 0

    while count < 3:
        print("Checking...")
        count += 1

This is different from a for loop.

A for loop is often used when you have a collection or a known sequence of
values.

A while loop is useful when repetition should continue until a condition
changes.

A long-running scheduler commonly uses:

    while True:
        ...

True never becomes false on its own, so the loop continues until something
stops it.

That something could be a keyboard interruption, an exception, or an explicit
shutdown mechanism.

### Step-by-step example

See:

    ../examples/3.5/3-5-step1-while-loop.py

The example deliberately stops after three iterations so you can run it
without creating a permanent process.

---

## 3. Why time.sleep() Matters

A loop like this would run continuously:

    while True:
        check_for_work()

It could check thousands of times per second.

That is unnecessary.

Use time.sleep() to pause before checking again:

    import time

    while True:
        check_for_work()
        time.sleep(1)

The argument is the number of seconds to sleep.

For a scheduler, the sleep interval controls how often the program asks:

> Is anything ready to run now?

A shorter interval checks more often.

A longer interval uses less CPU but can delay the next check.

The scheduler does not need to run every job every second. It only needs to
check often enough for the application's requirements.

---

## 4. Installing the schedule Package

The project adds schedule to requirements.txt.

Install the project dependencies in the same way you installed earlier
third-party packages.

The package provides a small API for recurring jobs.

The basic pattern is:

    import schedule

    def job():
        print("Working")

    scheduler = schedule.Scheduler()
    scheduler.every(10).minutes.do(job)

The job function is passed to do() rather than called immediately.

Compare:

    scheduler.every(10).minutes.do(job)

with:

    scheduler.every(10).minutes.do(job())

The first gives the scheduler the function.

The second calls the function immediately and gives its return value to do().

This distinction matters whenever a function is used as a callback.

---

## 5. Scheduling an Interval

The scheduler supports intervals such as seconds, minutes, hours, and days.

For example:

    scheduler.every(30).minutes.do(job)

This means the job should run every 30 minutes.

For a short experiment, use seconds:

    scheduler.every(5).seconds.do(job)

The project uses an interval in minutes because the Workspace Automation
Engine is intended for recurring workspace work rather than a rapid demo.

See:

    ../examples/3.5/3-5-step2-schedule.py

The example uses run_all() so the scheduled job can be demonstrated
immediately instead of waiting for the clock.

---

## 6. Scheduling a Daily Job

A recurring daily job can run at a specific time:

    scheduler.every().day.at("09:00").do(job)

The time uses a 24-hour clock.

This is useful when the task has a business-oriented schedule, such as a
report that should be refreshed each morning.

The application can have both kinds of schedules:

    scheduler.every(30).minutes.do(run_pipeline)
    scheduler.every().day.at("09:00").do(run_pipeline)

Both schedules can point to the same pipeline.

The scheduler decides when the function runs. The pipeline decides what work
happens.

---

## 7. Scheduling Does Not Perform the Work

Registering a job is not the same as running it.

After registration, the process must periodically check for pending jobs:

    while True:
        scheduler.run_pending()
        time.sleep(1)

run_pending() asks the scheduler to run jobs whose scheduled time has arrived.

This gives us the complete loop:

    create scheduler
        ↓
    register jobs
        ↓
    keep process alive
        ↓
    run pending jobs
        ↓
    sleep
        ↓
    check again

That pattern is the core of this chapter.

---

## 8. Separate Scheduling From Task Logic

It would be tempting to put all of the following into one large function:

- scan the workspace;
- update JSON;
- generate a report;
- create backups;
- register schedules;
- keep the process alive.

That makes the program difficult to change.

Instead, keep three responsibilities separate.

### Task logic

Task modules perform useful work.

Examples:

    tasks/index_task.py
    tasks/csv_reporter.py
    tasks/backup_task.py

### Orchestration logic

automation_engine.py decides which tasks belong together and in what order.

### Scheduling logic

scheduler.py decides when the pipeline should run.

This is still procedural Python. We are separating responsibilities without
introducing classes.

---

## 9. Passing Functions to the Pipeline

A function can be stored in a variable or a list.

For example:

    def update_index():
        print("Index updated.")

    def generate_report():
        print("Report generated.")

    tasks = [update_index, generate_report]

    for task in tasks:
        task()

The list contains the functions themselves.

The loop retrieves each function and calls it.

This lets an orchestration function work with a collection of tasks without
hard-coding every step into the loop.

See:

    ../examples/3.5/3-5-step3-orchestration.py

This builds directly on functions as arguments and values from earlier
chapters.

---

## 10. Introducing automation_engine.py

The project now gains its first explicit automation_engine.py module.

At this stage, the name means a procedural orchestration module.

It is not a class.

A simple pipeline can look like:

    def run_pipeline(tasks, logger):
        results = []

        for name, task in tasks:
            result = run_task(name, task, logger)
            results.append((name, result))

            if result is False:
                break

        return results

The engine knows the sequence of tasks.

It does not need to know how the index is built or how CSV files are written.

That work stays inside the task modules.

The full AutomationEngine object is deliberately deferred to Chapter 3.7.

---

## 11. Why Task Order Matters

The Workspace Automation Engine has dependencies between tasks.

The report should describe the current Workspace Index.

Therefore:

    Update Index
        ↓
    Generate Report

is correct.

The reverse order is misleading:

    Generate Report
        ↓
    Update Index

The report would be based on the previous state.

The same idea applies to other workflows.

Before automating a sequence, ask:

1. What state does each task read?
2. What state does each task change?
3. Which task must happen first?
4. What should happen if an earlier task fails?

The scheduler does not answer these questions.

The orchestration layer does.

---

## 12. Stopping the Pipeline After a Critical Failure

Suppose updating the Workspace Index fails.

Should the report still run?

Usually not.

The report could describe stale or missing state.

The procedural engine therefore stops the pipeline when a task reports
failure.

For example:

    if result is False:
        logger.error("Pipeline stopped")
        break

This uses the failure-handling ideas from Chapter 3.4.

Not every failure needs to stop an entire pipeline. The decision belongs to the
workflow being automated.

---

## 13. Preventing Duplicate Schedule Registration

A common scheduling mistake is registering the same job repeatedly.

Imagine this code runs twice:

    scheduler.every(30).minutes.do(run_pipeline)
    scheduler.every(30).minutes.do(run_pipeline)

Now two jobs are registered.

The pipeline could execute twice every 30 minutes.

The schedule library supports job tags. The project uses a tag to identify
each kind of registration:

    scheduler.every(30).minutes.do(job).tag("automation-interval")

Before registering another job, check whether that tag already exists:

    if scheduler.get_jobs("automation-interval"):
        return False

This gives registration a clear rule:

> Register this schedule once.

It also makes the scheduler component easier to test.

---

## 14. Building a Reusable Scheduler Component

Move scheduling details into scheduler.py.

A reusable interval registration function can be:

    def register_interval_job(scheduler, interval_minutes, job):
        if scheduler.get_jobs("automation-interval"):
            return False

        scheduler.every(interval_minutes).minutes.do(job)
        return True

A daily registration function follows the same pattern.

The rest of the application does not need to know how schedule jobs are
represented internally.

See:

    ../examples/3.5/3-5-step4-scheduler-component.py

The example registers both an interval job and a daily job.

---

## 15. Graceful Shutdown

A long-running process needs a way to stop.

When you run a Python program in a terminal, pressing Ctrl+C raises
KeyboardInterrupt.

Handle it explicitly:

    try:
        while True:
            scheduler.run_pending()
            time.sleep(1)
    except KeyboardInterrupt:
        logger.info("Automation scheduler stopped.")

This is graceful shutdown.

The program records that it stopped rather than producing an unexplained
traceback.

The handler should stay focused.

It should not catch every exception and pretend the process stopped normally.

Unexpected programming errors should remain visible.

---

## 16. Logging Scheduled Runs

Chapter 3.4 introduced logging.

Now logging becomes especially useful because the program may run when nobody
is watching it.

Record important events:

    logger.info("Automation scheduler started.")
    logger.info("Starting task: Update Workspace Index")
    logger.info("Finished task: Update Workspace Index")
    logger.info("Automation scheduler stopped.")

These messages help answer:

- Did the scheduler start?
- Did the pipeline run?
- Which task ran?
- Did a task fail?
- Did the process shut down?

This is operational visibility.

---

## 17. The Complete Automation Pipeline

The final project combines the pieces:

    def scheduled_pipeline():
        run_once(logger)

    register_interval_job(
        scheduler,
        INTERVAL_MINUTES,
        scheduled_pipeline,
    )

    register_daily_job(
        scheduler,
        DAILY_TIME,
        scheduled_pipeline,
    )

    run_scheduler(
        scheduler,
        CHECK_INTERVAL_SECONDS,
        logger,
    )

The scheduler knows when to call scheduled_pipeline.

The automation engine knows that the pipeline is:

1. update the Workspace Index;
2. generate the report;
3. create the backup.

The individual task modules know how to perform those operations.

Each layer has one main responsibility.

---

## 18. Running the Pipeline Once

A long-running scheduler is awkward when you only want to verify the
pipeline.

The solution therefore exposes a one-run mode:

    python main.py --once

This runs the task pipeline immediately and exits.

It is useful for:

- testing;
- development;
- checking the workspace;
- verifying task order;
- debugging a deployment before enabling recurring execution.

The normal command:

    python main.py

starts the scheduler and keeps the process alive.

This distinction is useful in real applications: one function can perform the
work, while another function controls when that work is triggered.

---

## 19. Testing Without Waiting for Real Time

Automated tests should not wait 30 minutes to prove that a 30-minute job was
registered.

Instead, test the scheduler's behavior directly.

For example, verify:

- an interval registration creates one job;
- registering the same interval again does not create a second job;
- a daily registration creates a job;
- KeyboardInterrupt is handled;
- the pipeline executes tasks in the expected order;
- the pipeline stops after a critical task failure.

This tests scheduling logic without depending on the wall clock.

The example tests also run the short demonstrations directly.

The complete solution tests use temporary directories for filesystem work.

---

## 20. Step-by-Step Examples

The examples introduce the ideas in small pieces.

### Step 1 — Keep a process alive

Learn the while loop and time.sleep() pattern without introducing the
scheduler.

See:

    ../examples/3.5/3-5-step1-while-loop.py

### Step 2 — Register a scheduled job

Use the schedule package and inspect a registered job.

See:

    ../examples/3.5/3-5-step2-schedule.py

### Step 3 — Coordinate task functions

Store task functions in a list and execute them in order.

See:

    ../examples/3.5/3-5-step3-orchestration.py

### Step 4 — Separate scheduler registration

Build reusable interval and daily registration functions.

See:

    ../examples/3.5/3-5-step4-scheduler-component.py

### Step 5 — Build the complete scheduler

Combine recurring jobs, orchestration, logging, and graceful shutdown.

See:

    ../examples/3.5/3-5-automation-engine.py

---

## 21. The Complete Project

The project solution contains:

### main.py

The entry point configures logging, supports one-run execution, registers the
recurring pipeline, and starts the scheduler.

### automation_engine.py

This is the procedural orchestration layer.

It:

- runs tasks in order;
- logs task boundaries;
- collects task results;
- stops the pipeline after a failure;
- builds the three-task Workspace Automation pipeline.

### scheduler.py

This module owns recurring execution.

It:

- creates a scheduler;
- registers interval jobs;
- registers daily jobs;
- prevents duplicate registrations;
- runs pending jobs in a loop;
- handles KeyboardInterrupt.

### tasks/index_task.py

This task scans the workspace and writes the current Workspace Index.

### tasks/csv_reporter.py

This task reads the current Workspace Index and writes a CSV report.

### tasks/backup_task.py

This task backs up workspace files without silently overwriting an existing
backup.

### logging_utils.py

This module keeps logging configuration separate from task and scheduling
logic.

---

## 22. Exercise: Add a Second Interval

Add another scheduled job for a different task.

Do not copy the scheduler loop.

Instead, add another registration function call and give the job its own tag.

Think about whether the new job should run the complete pipeline or only one
task.

---

## 23. Exercise: Add a Dry Run

Add a command-line option that reports what the pipeline would do without
changing files.

Keep scheduling out of this exercise.

The goal is to practice separating:

- deciding what should happen;
- actually performing the operation.

---

## 24. Exercise: Improve Shutdown Logging

Add a final message that records how many scheduled jobs were registered when
the scheduler stopped.

Use the scheduler's existing job collection.

Do not introduce a class.

---

## New Versus Reused Concepts Recap

### New Concepts Recap

You now know:

- how a while loop can keep a process alive;
- how time.sleep() controls repeated checks;
- how to register recurring jobs with schedule;
- how interval and daily schedules differ;
- how to coordinate several functions as a pipeline;
- how to separate scheduling from orchestration;
- how to prevent duplicate schedule registration;
- how to handle KeyboardInterrupt for graceful shutdown.

### Reused Concepts Recap

You applied:

- functions and return values;
- loops and conditionals;
- exceptions;
- logging;
- modules;
- third-party packages;
- pathlib and file operations;
- dictionaries and JSON;
- the Workspace Index;
- the reliability patterns from Chapter 3.4.

The project is still procedural. The next major change is object-oriented
design, not another scheduling feature.

---

## Chapter Recap

The key ideas are:

1. A scheduler decides when work should run.
2. A while loop keeps a scheduler process alive.
3. time.sleep() prevents the loop from checking continuously.
4. The schedule package registers recurring jobs.
5. Scheduling and task implementation should remain separate.
6. automation_engine.py coordinates tasks without being a class.
7. Task order matters when later tasks depend on updated state.
8. Duplicate schedule registration should be prevented.
9. KeyboardInterrupt can provide a clean shutdown path.
10. Tests should verify scheduling behavior without waiting for real time.

The Workspace Automation Engine can now run its pipeline automatically instead
of depending on someone to start every task manually.

## Project Evolution

The Workspace Automation Engine has now evolved like this:

    3.1  Workspace
          ↓
         DownloadOrganizer
          ↓
    3.2  + Workspace Index
          ↓
    3.3  + CsvReporter
          ↓
    3.4  + BackupTask
         + Validation
         + Exception Handling
         + Logging
          ↓
    3.5  + automation_engine.py
         + Scheduler
         + Recurring Execution

The orchestration layer is still procedural.

Chapter 3.6 moves the application toward configuration and deployment,
including environment-specific settings and operating-system scheduling.

Chapter 3.7 later introduces classes and the formal AutomationTask /
AutomationEngine framework.

## Next Chapter

### Chapter 3.6 — Deploying the Automation Engine

The next chapter moves the automation from a development project toward an
application that can be configured and deployed reliably.

## Further Reading

- Python documentation: while statements
- Python documentation: time.sleep()
- schedule documentation
- Chapter 3.4 — Building Reliable Automations
- Chapter 3.6 — Deploying the Automation Engine
