import SwiftUI
import UserNotifications

struct NotificationsDemoView: View {
    @State private var isAuthorized = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        List {
            Section("Notification Authorization") {
                Button("Request Authorization") {
                    requestAuthorization()
                }
                .buttonStyle(.bordered)
                
                HStack {
                    Text("Authorization Status")
                    Spacer()
                    Text(isAuthorized ? "Authorized" : "Not Authorized")
                        .foregroundStyle(isAuthorized ? .green : .red)
                }
            }
            
            Section("Schedule Notifications") {
                Button("Schedule 5 Second Notification") {
                    scheduleNotification(timeInterval: 5)
                }
                .buttonStyle(.bordered)
                
                Button("Schedule 10 Second Notification") {
                    scheduleNotification(timeInterval: 10)
                }
                .buttonStyle(.bordered)
                
                Button("Schedule Custom Notification") {
                    scheduleCustomNotification()
                }
                .buttonStyle(.bordered)
            }
            
            Section("Notification Categories") {
                Button("Schedule Actionable Notification") {
                    scheduleActionableNotification()
                }
                .buttonStyle(.bordered)
            }
            
            Section("Notification Management") {
                Button("Remove All Pending Notifications") {
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    alertMessage = "All pending notifications removed"
                    showingAlert = true
                }
                .buttonStyle(.bordered)
                .tint(.red)
                
                Button("Remove All Delivered Notifications") {
                    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                    alertMessage = "All delivered notifications removed"
                    showingAlert = true
                }
                .buttonStyle(.bordered)
                .tint(.red)
            }
        }
        .navigationTitle("Notifications Demo")
        .alert("Notification Status", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .onAppear {
            checkAuthorizationStatus()
        }
    }
    
    func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            DispatchQueue.main.async {
                isAuthorized = success
                if let error = error {
                    alertMessage = error.localizedDescription
                    showingAlert = true
                }
            }
        }
    }
    
    func scheduleNotification(timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "SwiftUI Demo"
        content.body = "This is a test notification"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                DispatchQueue.main.async {
                    alertMessage = error.localizedDescription
                    showingAlert = true
                }
            }
        }
    }
    
    func scheduleCustomNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Custom Notification"
        content.body = "This is a custom notification with an image"
        content.sound = .default
        
        // Add an image attachment
        if let imageURL = Bundle.main.url(forResource: "notification_image", withExtension: "jpg") {
            let attachment = try? UNNotificationAttachment(identifier: "image", url: imageURL, options: nil)
            if let attachment = attachment {
                content.attachments = [attachment]
            }
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleActionableNotification() {
        // Define actions
        let acceptAction = UNNotificationAction(
            identifier: "ACCEPT_ACTION",
            title: "Accept",
            options: .foreground
        )
        
        let declineAction = UNNotificationAction(
            identifier: "DECLINE_ACTION",
            title: "Decline",
            options: .destructive
        )
        
        // Create category
        let category = UNNotificationCategory(
            identifier: "MEETING_CATEGORY",
            actions: [acceptAction, declineAction],
            intentIdentifiers: [],
            options: []
        )
        
        // Register category
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "Meeting Reminder"
        content.body = "You have a meeting in 5 minutes"
        content.sound = .default
        content.categoryIdentifier = "MEETING_CATEGORY"
        
        // Schedule notification
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}

#Preview {
    NavigationStack {
        NotificationsDemoView()
    }
} 