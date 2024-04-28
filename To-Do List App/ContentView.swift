//
//  ContentView.swift
//  To-Do List App
//
//  Created by Justin Dong on 4/27/24.
//


import SwiftUI

struct ContentView: View {
    @State private var tasks: [Task] = []
    @State private var newTaskName = ""
    @State private var newTaskDueDate = Date()
    @State private var newTaskDueTime = Date()
    @State private var scheduledDateTime: Date? = nil // Arjun Subedi 4/27/2024
    

    var body: some View {
        VStack {
           
            Text("CasualTasks")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, -15)

            ScrollView {
                VStack(spacing: 15) {
                    ForEach(tasks) { task in
                        TaskView(task: task, toggleTaskCompletion: toggleTaskCompletion)
                            .padding(.horizontal, 20)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            VStack(spacing: 10) {
                TextField("Enter task name", text: $newTaskName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                VStack(alignment: .leading, spacing: 5) {
                    Text("Due Date:")
                    DatePicker("", selection: $newTaskDueDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text("Due Time:")
                    DatePicker("", selection: $newTaskDueTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(GraphicalDatePickerStyle())
                }

                Button(action: {
                    // Add a new task
                    let task = Task(name: newTaskName, dueDate: combineDateAndTime(date: newTaskDueDate, time: newTaskDueTime))
                    tasks.append(task)
                    // Reset fields
                    newTaskName = ""
                    newTaskDueDate = Date()
                    newTaskDueTime = Date()
                }) {
                    Text("Add Task")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Text("Schedule Task") // Users are able to set any date and time
                        .font(.headline)
                        .padding(.top, 20)

                DatePicker("Schedule Date and Time", selection: Binding<Date>(
                    get: { self.scheduledDateTime ?? Date() },
                    set: { self.scheduledDateTime = $0 }
                ), displayedComponents: [.date, .hourAndMinute])


                Button(action: {
                    self.scheduleTaskExecution() // Call scheduleTaskExecution() on self
                }) {
                    Text("Schedule Task")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .padding()
    }

    func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }

    func combineDateAndTime(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        return calendar.date(bySettingHour: timeComponents.hour!, minute: timeComponents.minute!, second: 0, of: calendar.date(from: dateComponents)!)!
    }

    // Move scheduleTaskExecution() inside ContentView struct
    func scheduleTaskExecution() {
        guard let scheduledDateTime = self.scheduledDateTime else {
            return
        }

        let timer = Timer(fire: scheduledDateTime, interval: 0, repeats: false) { _ in
            print("Task scheduled for \(scheduledDateTime) executed")
        }

        RunLoop.current.add(timer, forMode: .common)
        self.scheduledDateTime = nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Task: Identifiable {
    let id = UUID()
    let name: String
    var dueDate: Date
    var isCompleted: Bool = false
}

struct TaskView: View {
    let task: Task
    let toggleTaskCompletion: (Task) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Button(action: {
                    toggleTaskCompletion(task)
                }) {
                    Image(systemName: task.isCompleted ? "checkmark.square" : "square")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(task.isCompleted ? .green : .secondary)
                }
                Text(task.name)
                    .font(.headline)
            }
            Text("Due: \(task.dueDate, style: .date) at \(task.dueDate, style: .time)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(15)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
