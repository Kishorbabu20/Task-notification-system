**Task Notification System**

This is a simple task management system built using **Ruby** and **SQLite3**, designed to help users track their daily tasks. The system allows users to add, list, complete, and delete tasks. It also includes an automatic notification feature that reminds users about due tasks using **Windows Toast Notifications** or a **VBScript pop-up message**.

## **Overview**
- Uses **SQLite3** to store tasks.
- Supports **adding, listing, marking as complete, and deleting tasks**.
- **Daily notifications** for due tasks.
- Implemented using **Ruby** and **VBScript** for pop-up alerts.
- Can be scheduled to run automatically using **Windows Task Scheduler**.

## **Key Features**
- **Task Management**: Add, view, update, and delete tasks.
- **Task Status Tracking**: Keeps track of completed and pending tasks.
- **Daily Reminders**: Notifies users about due tasks each day.
- **Lightweight and Simple**: Uses SQLite3 for minimal setup.

## **Usage**
### **1. Adding a Task**
```ruby
add_task("Finish Report", "Complete the project report", "2025-02-17")
```

### **2. Listing All Tasks**
```ruby
list_tasks
```

### **3. Marking a Task as Completed**
```ruby
complete_task(1)
```

### **4. Deleting a Task**
```ruby
delete_task(2)
```

## Configuration
### 1. Install Dependencies
Ensure **Ruby** and **SQLite3** are installed:
```sh
 gem install sqlite3
```

### 2. Schedule Daily Notifications (Windows)
1. Open **Task Scheduler** (`Win + R`, type `taskschd.msc`, press Enter).
2. Click **Create Basic Task** → Name it **Task Reminder**.
3. Set **Trigger** to **Daily** (or repeat at a custom interval).
4. Set **Action** to **Start a Program** → Select `ruby.exe` and add `task_notifier.rb` as an argument.
5. Save and Enable the task.

### 3. Running the Script Manually
```sh
ruby task_notifier.rb
```

## Conclusion
This system ensures users never miss their important tasks by providing **daily reminders**. The combination of **SQLite3 for storage** and **Windows notifications** makes it a lightweight yet effective task management solution. Further enhancements could include GUI integration or mobile alerts for a more interactive experience.

