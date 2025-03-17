import SwiftUI

struct ProfileView: View {
    @ObservedObject var habitStore: HabitStore
    @Environment(\.dismiss) var dismiss
    
    private var completionPercentage: Int {
        guard !habitStore.habits.isEmpty else { return 0 }
        return Int((Double(habitStore.completedHabitsToday.count) / Double(habitStore.habits.count)) * 100)
    }
    
    private var credits: Int {
        habitStore.completedHabitsToday.count * 10 + habitStore.longestStreak
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    ZStack(alignment: .bottomLeading) {
                        Circle()
                            .fill(Color.purple)
                            .frame(width: 120, height: 120)
                            .overlay(
                                Text("\(completionPercentage)%")
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.white)
                            )
                        
                        Text("You")
                            .font(.title)
                            .bold()
                            .padding(.leading)
                            .padding(.bottom, 40)
                        
                        Text("Open to chat")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(.systemGray6))
                            .cornerRadius(16)
                            .padding(.leading)
                    }
                    .padding(.top)
                    
                    // Question Card
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "house.fill")
                                .foregroundColor(.purple)
                                .font(.title2)
                            
                            Text("Are you an introvert or an extrovert?")
                                .font(.headline)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    
                    // Stats Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Plans")
                            .font(.title2)
                            .bold()
                        
                        HStack(spacing: 16) {
                            // Activity Card
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Your activity")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                HStack {
                                    Image(systemName: "gauge")
                                        .foregroundColor(.green)
                                    Text("High")
                                        .font(.title2)
                                        .bold()
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemBackground))
                            .cornerRadius(16)
                            
                            // Credits Card
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Credits")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                HStack {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.yellow)
                                    Text("\(credits)")
                                        .font(.title2)
                                        .bold()
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemBackground))
                            .cornerRadius(16)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Premium Card
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.purple)
                            Text("Premium Features")
                                .font(.title3)
                                .bold()
                        }
                        
                        Text("Get access to advanced habit tracking features and unlock your full potential")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                        
                        Button(action: {}) {
                            Text("Upgrade From $8.99")
                                .font(.headline)
                                .foregroundColor(.purple)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 24)
                                .background(Color(.systemBackground))
                                .cornerRadius(20)
                        }
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(24)
                    .padding(.horizontal)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
} 