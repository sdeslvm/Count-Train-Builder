import Foundation
import SwiftUI

struct CountTrainEntryScreen: View {
    @StateObject private var loader: CountTrainWebLoader

    init(loader: CountTrainWebLoader) {
        _loader = StateObject(wrappedValue: loader)
    }

    var body: some View {
        ZStack {
            CountTrainWebViewBox(loader: loader)
                .opacity(loader.state == .finished ? 1 : 0.5)
            switch loader.state {
            case .progressing(let percent):
                CountTrainProgressIndicator(value: percent)
            case .failure(let err):
                CountTrainErrorIndicator(err: err)  // err теперь String
            case .noConnection:
                CountTrainOfflineIndicator()
            default:
                EmptyView()
            }
        }
    }
}

private struct CountTrainProgressIndicator: View {
    let value: Double
    var body: some View {
        GeometryReader { geo in
            CountTrainLoadingOverlay(progress: value)
                .frame(width: geo.size.width, height: geo.size.height)
                .background(Color.black)
        }
    }
}

private struct CountTrainErrorIndicator: View {
    let err: String  // было Error, стало String
    var body: some View {
        Text("Ошибка: \(err)").foregroundColor(.red)
    }
}

private struct CountTrainOfflineIndicator: View {
    var body: some View {
        Text("Нет соединения").foregroundColor(.gray)
    }
}
