//
//  HomeView.swift
//
//
//  Created by Ya Wei Tsai on 2024/2/14.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var mealViewModel: MealViewModel
    @ObservedObject var petActivitiesViewModel: PetActivitiesViewModel
    @State private var showingGame = false
    @State private var showingImagePicker = false
    @State private var backgroundImage: UIImage?
    @State private var showingInfoAlert = false
    private var infoButton: some View {
        Button(action: {
            showingInfoAlert = true
        }) {
            Image(systemName: "info.circle")
                .font(.system(size: 20))
                .foregroundColor(.pink)
        }
        .alert(isPresented: $showingInfoAlert) {
            Alert(
                title: Text("How to Use"),
                message: Text("This app allows you to manage and track your meals and pet activities. Use the 'Play Game' button to enjoy our interactive game. Use the 'Change Background Image' to personalize the app's background."),
                dismissButton: .default(Text("Got it!"))
            )
        }
    }



    var body: some View {
        
            NavigationView {
                VStack {
                    HStack{
                        changeImageButton
                            .padding(.top, 100)
                        infoButton
                            .padding(.top, 100)

                    }
                    Spacer()

                    contentView
                        .padding(.horizontal)

                    Spacer()
                    HStack {
                        gameButton
                        resetBackgroundButton
                    }
                    .padding(.bottom, 100)
                }
                .navigationBarTitle("Upcoming Activities", displayMode: .inline)
                .onAppear {
                    mealViewModel.removePastMeals()
                    petActivitiesViewModel.removePastActivities()
                    self.backgroundImage = loadImageFromDisk()

                }
                .background(backgroundImageView)
                .edgesIgnoringSafeArea(.all) // Ensure background extends to the edges
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(selectedImage: $backgroundImage)
                }.onChange(of: backgroundImage) { _ in
                    print("Background image is about to change.")
                    if let selectedImage = self.backgroundImage {
                        print("Saving new image to disk.")
                        saveImageToDisk(image: selectedImage)
                    }
                
                }
            }
        }

    private var backgroundImageView: some View {
        Group {
            if let backgroundImage = backgroundImage {
                Image(uiImage: backgroundImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image("puppy")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)

    }
    private var contentView: some View {
            VStack() {
                mealAndActivitySection

        }
    }
    
    private var mealAndActivitySection: some View {
        VStack(spacing: 10) { // Add spacing for visual separation within the group
            if let closestMeal = mealViewModel.closestMeal, closestMeal.time > Date() {
                Text("Next Meal: \(closestMeal.type)")
                    .font(.custom("Chalkduster", size: 18))

                Text("Dish: \(closestMeal.name)")
                    .font(.custom("Chalkduster", size: 16))

                CountdownTimerView(endDate: closestMeal.time)
            } else {
                Text("No meals scheduled")
                    .font(.custom("Chalkduster", size: 16))
            }

            if let nextActivity = petActivitiesViewModel.activities.filter({ $0.time > Date() }).sorted(by: { $0.time < $1.time }).first {
                Text("Next Pet Activity: \(nextActivity.type)")
                    .font(.custom("Chalkduster", size: 18))
                CountdownTimerView(endDate: nextActivity.time)
            } else {
                Text("No upcoming pet activities")
                    .font(.custom("Chalkduster", size: 16))
            }
        }
        .padding() // Add padding inside the VStack for better spacing
        .background(Color.pink.opacity(0.5)) // Apply the pink background with transparency
        .cornerRadius(10) // Optional: Apply corner radius to smooth the edges
        .foregroundColor(.white)
    }

    private var gameButton: some View {
        Button("Play Game") {
            showingGame = true
        }
        .font(.custom("Chalkduster", size: 15))
        .padding()
        .foregroundColor(.white)
        .background(Color.pink.opacity(0.5))
        .clipShape(Capsule())
 
        .fullScreenCover(isPresented: $showingGame, content: GameSceneView.init)
    }
    
    private var changeImageButton: some View {
        Button(action: {
            showingImagePicker = true
        }) {
            HStack {
                Image(systemName: "photo") // SF Symbol for a photo icon
                    .font(.system(size: 20))
                Text("Change Background Image")
                    .font(.custom("Chalkduster", size: 15))
            }
            .foregroundColor(.pink)
        }
    }

    private var resetBackgroundButton: some View {
        Button("Reset Background Image") {
            backgroundImage = nil // Resets the background image to the default
            clearSavedImage()

        }
        .font(.custom("Chalkduster", size: 15))
        .padding()
        .foregroundColor(.white)
        .background(Color.pink.opacity(0.5))
        .clipShape(Capsule())
    }
}


struct CountdownTimerView: View {
    let endDate: Date
    @State private var timeRemaining: String = ""
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        Text(timeRemaining)
            .onAppear(perform: updateTimer)
            .onReceive(timer) { _ in
                updateTimer()
            }
    }
    // update the activites or the meal's timer
    private func updateTimer() {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: now, to: endDate)
        
        if let day = components.day, let hour = components.hour, let minute = components.minute, let second = components.second {
            timeRemaining = "\(day)d \(hour)h \(minute)m \(second)s"
        }
    }
}


extension HomeView {
    func saveImageToDisk(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 1) else { return }
        let fileName = "savedBackgroundImage.jpeg" // Constant filename
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)

        do {
            try imageData.write(to: filePath)
            UserDefaults.standard.set(fileName, forKey: "backgroundImage")
            print("Image successfully saved to \(filePath)")
        } catch {
            print("Could not save the image to disk: \(error)")
        }
    }

    func loadImageFromDisk() -> UIImage? {
        guard let fileName = UserDefaults.standard.string(forKey: "backgroundImage") else { return nil }
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName).path
        if FileManager.default.fileExists(atPath: filePath) {
            return UIImage(contentsOfFile: filePath)
        } else {
            return nil
        }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func clearSavedImage() {
        UserDefaults.standard.removeObject(forKey: "backgroundImage")
        if let fileName = UserDefaults.standard.string(forKey: "backgroundImage") {
            let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
            try? FileManager.default.removeItem(at: filePath)
        }
    }

}

