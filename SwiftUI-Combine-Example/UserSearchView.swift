import SwiftUI

struct UserSearchView: View {
    @EnvironmentObject var repository: UserRepository
    @State var text = "ra1028"

    var body: some View {
        NavigationView {
            VStack {
                UserSearchBar(text: $text) {
                    self.repository.search(name: self.text)
                }

                List(repository.users) { user in
                    UserRow(user: user)
                        .tapAction { print(user) }
                }
                }
                .navigationBarTitle(Text("Users"))
        }
    }
}
