import SwiftUI

struct UserSearchView: View {
    @EnvironmentObject var viewModel: SearchUserViewModel
    @State var text = "ra1028"

    var body: some View {
        NavigationView {
            VStack {
                UserSearchBar(text: $text) {
                    self.viewModel.search(name: self.text)
                }

                List(viewModel.users) { user in
                    UserRow(user: user)
                        .tapAction { print(user) }
                }
                }
                .navigationBarTitle(Text("Users"))
        }
    }
}
