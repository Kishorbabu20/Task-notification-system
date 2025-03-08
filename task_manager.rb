require 'sqlite3'
require 'date'

# Initialize database connection
DB = SQLite3::Database.new "tasks.db"
DB.results_as_hash = true

# Ensure table exists
DB.execute <<-SQL
  CREATE TABLE IF NOT EXISTS tasks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    description TEXT,
    due_date TEXT,
    status INTEGER DEFAULT 0 -- 0: Incomplete, 1: Complete
  );
SQL

# Function to show notification popup using PowerShell
def show_notification(message)
  powershell_script = <<-PS
    $notification = New-Object System.Windows.Forms.NotifyIcon
    $notification.Icon = [System.Drawing.SystemIcons]::Information
    $notification.BalloonTipText = "#{message}"
    $notification.BalloonTipTitle = "Task Reminder"
    $notification.Visible = $true
    $notification.ShowBalloonTip(5000)
    Start-Sleep -Seconds 5
    $notification.Dispose()
  PS

  File.write("notify.ps1", powershell_script)
  system("powershell -ExecutionPolicy Bypass -File notify.ps1")
  File.delete("notify.ps1") # Cleanup
end

# Function to check due tasks and notify
def check_due_tasks
  today = Date.today.to_s
  tasks = DB.execute("SELECT * FROM tasks WHERE due_date = ? AND status = 0", [today])

  tasks.each do |task|
    show_notification("Did you complete your task: #{task['title']}?")
  end
end

# Add a new task
def add_task(title, description, due_date)
  DB.execute("INSERT INTO tasks (title, description, due_date, status) VALUES (?, ?, ?, 0)", [title, description, due_date])
  puts "Task added successfully!"
end

# List all tasks
def list_tasks
  tasks = DB.execute("SELECT * FROM tasks")

  if tasks.empty?
    puts "No tasks found!"
  else
    puts "\nTask List:"
    tasks.each do |task|
      puts "#{task['id']}. [#{task['status'] == 1 ? '✔' : '✗'}] #{task['title']} - Due: #{task['due_date']}"
    end
  end

  # Trigger notifications for due tasks
  check_due_tasks
end

# Update task status
def complete_task(id)
  DB.execute("UPDATE tasks SET status = 1 WHERE id = ?", [id])
  if DB.changes > 0
    puts "Task marked as completed!"
  else
    puts "Task not found!"
  end
end

# Delete a task
def delete_task(id)
  DB.execute("DELETE FROM tasks WHERE id = ?", [id])
  if DB.changes > 0
    puts "Task deleted!"
  else
    puts "Task not found!"
  end
end

# CLI Menu
loop do
  puts "\nTask Manager:"
  puts "1. Add Task"
  puts "2. List Tasks"
  puts "3. Mark Task as Completed"
  puts "4. Delete Task"
  puts "5. Exit"
  print "Choose an option: "
  choice = gets.chomp.to_i

  case choice
  when 1
    print "Title: "
    title = gets.chomp
    print "Description: "
    description = gets.chomp
    print "Due Date (YYYY-MM-DD): "
    due_date = gets.chomp
    add_task(title, description, due_date)
  when 2
    list_tasks
  when 3
    print "Task ID to mark as completed: "
    id = gets.chomp.to_i
    complete_task(id)
  when 4
    print "Task ID to delete: "
    id = gets.chomp.to_i
    delete_task(id)
  when 5
    puts "Goodbye!"
    break
  else
    puts "Invalid option, try again."
  end
end
