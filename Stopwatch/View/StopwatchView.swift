import SwiftUI

struct StopwatchView: View {
    @StateObject var viewModel = StopwatchViewModel()
    
    var body: some View {
        VStack(spacing: 90) {
            StopwatchHeader()
            
            Picker("", selection: $viewModel.selectedStopwatchToggle) {
                ForEach(StopwatchToggleType.allCases, id: \.id) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(.menu)
            .tint(.purple)
            .background(Color.white)
            
            Text(viewModel.timeString)
                .padding(16)
                .background(Color.purple.opacity(0.3))
                .cornerRadius(16)
            
            Spacer()
            
            HStack {
                Button(action: viewModel.isTimeRunning ? viewModel.stopTimer : viewModel.startTimer) {
                    if viewModel.isTimeRunning{
                        Text("Pause")
                    } else {
                        if viewModel.elapsedTime > 0 {
                            Text("Resume")
                        } else {
                            Text("Start")
                        }
                    }
                }
                .padding(16)
                .frame(width: (UIScreen.main.bounds.width - 48) / 2)
                .background(Color.purple)
                .cornerRadius(8)
                .foregroundColor(.white)
                
                
                Spacer()
                
                Button(action: viewModel.resetTimer) {
                    Text("Reset")
                }
                .padding(16)
                .frame(width: (UIScreen.main.bounds.width - 48) / 2)
                .background(Color.purple)
                .cornerRadius(8)
                .foregroundColor(.white)
            }
        }
        .background(Color.black)
        .padding(16)
        .onChange(of: viewModel.selectedStopwatchToggle) { newValue in
            viewModel.resetTimer()
        }
    }
}

struct StopwatchHeader: View {
    var body: some View {
        Text("Stopwatch")
            .font(.title)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    StopwatchView()
        .colorScheme(.dark)
}
