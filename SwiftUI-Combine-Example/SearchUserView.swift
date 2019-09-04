import SwiftUI

struct SearchUserView: View {
    @ObservedObject var viewModel = SearchUserViewModel()

    var body: some View {
        NavigationView {
            VStack {
                SearchUserBar(text: $viewModel.name) {
                    self.viewModel.search()
                }

                List(viewModel.users) { user in
                    SearchUserRow(viewModel: self.viewModel, user: user)
                        .onAppear { self.viewModel.fetchImage(for: user) }
                }
                }
                .navigationBarTitle(Text("Users"))
        }
    }
}
