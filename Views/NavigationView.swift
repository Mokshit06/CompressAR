import SwiftUI

struct PageNavigationView: View {
    @EnvironmentObject var userState: UserState
    
    @State private var showingAboutView = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("CompressAR")
                        .font(.footnote)
                    Text("Basics")
                        .font(.title3).fontWeight(.semibold)
                        .padding(.bottom, 20)
                    ProgressView(
                        value: Float(userState.completionProgress.count), total: Float(BasicsCourse.count))
                    HStack {
                        Text("\((userState.completionProgress.count) * 100 / BasicsCourse.count) % completed")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Button {
                            userState.resetCompletionProgress()
                        } label: {
                            Text("Reset progess")
                                .font(.caption)
                                .foregroundColor(.accentColor)
                        }
                        
                    }
                    .padding(.top, 2)
                    .padding(.bottom, 60)
                }
                
                Text("Lessons")
                    .font(.caption).fontWeight(.medium)
                    .padding(.bottom, 10)
                
                pageOverview
                
                Divider().padding(.vertical, 15)
                
                Text("Playground")
                    .font(.caption).fontWeight(.medium)
                    .padding(.bottom, 10)
                
                NavigationLink(
                    tag: 4,
                    selection: Binding(
                        get: { userState.currentPage },
                        set: { value in
                            userState.currentPage = value ?? 1
                        }),
                    destination: {
                        ARPlaygroundView().navigationBarTitleDisplayMode(.inline)
                    },
                    label: {
                        arLabel.padding(10)
                            .background(userState.currentPage == 4 ? Color.accentColor.opacity(0.1) : Color.clear)
                            .cornerRadius(10)
                    }
                ).environmentObject(userState)
            }
            Spacer()
            VStack {
                Button {
                    showingAboutView.toggle()
                } label: {
                    HStack {
                        Image(systemName: "info.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.accentColor)
                            .frame(width: 17, height: 17)
                            .padding(5)
                            .transition(.scale.combined(with: .opacity))
                        
                        Text("About this app")
                            .font(.footnote)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                }
            }
        }
        .frame(minWidth: 260, maxHeight: .infinity)
        .padding(18)
        .padding(.top, 25)
        .background(Color(uiColor: .secondarySystemBackground))
        .animation(
            Animation.timingCurve(0.44, 1.86, 0.61, 0.99, duration: 0.5),
            value: userState.completionProgress
        )
        .sheet(isPresented: $showingAboutView) {
            AboutView()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var arLabel: some View {
        HStack {
            if userState.completionProgress.contains("arplayground") {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.green)
                    .frame(width: 20, height: 20)
                    .padding(5)
                    .padding(.trailing, 4)
                    .transition(.scale.combined(with: .opacity))
            } else {
                Image(systemName: "arkit")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.accentColor)
                    .frame(width: 20, height: 20)
                    .padding(5)
                    .padding(.trailing, 4)
                    .transition(.scale.combined(with: .opacity))
            }
            Text("AR Playground")
                .font(.callout)
                .foregroundColor(.primary)
            Spacer()
        }
    }
    
    var pageOverview: some View {
        VStack(alignment: .leading) {
            VStack(spacing: 0) {
                ForEach(BasicsCourse.filter({ $0.id != "arplayground" }), id: \.self.id) { page in
                    NavigationLink(
                        destination: HStack(spacing: 0) {
                            PageContentView().environmentObject(userState)
                            Rectangle()
                                .foregroundColor(Color(uiColor: UIColor.secondarySystemBackground))
                                .frame(width: 2)
                            PagePlaygroundView().environmentObject(userState)
                        }.navigationBarTitleDisplayMode(.inline), tag: BasicsCourse.firstIndex(of: page)!,
                        selection: Binding(
                            get: { return userState.currentPage },
                            set: { value in
                                userState.currentPage = value ?? 1
                            }),
                        label: {
                            HStack {
                                if userState.completionProgress.contains(page.id) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(Color.green)
                                        .frame(width: 20, height: 20)
                                        .padding(5)
                                        .padding(.trailing, 4)
                                        .transition(.scale.combined(with: .opacity))
                                } else {
                                    Image(systemName: page.titleImageName)
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(Color.accentColor)
                                        .frame(width: 20, height: 20)
                                        .padding(5)
                                        .padding(.trailing, 4)
                                        .transition(.scale.combined(with: .opacity))
                                }
                                Text(page.title)
                                    .font(.callout)
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                            .padding(10)
                            .background(
                                page.id == BasicsCourse[userState.currentPage].id
                                ? Color.accentColor.opacity(0.1) : Color.clear
                            )
                            .cornerRadius(10)
                        }
                    ).environmentObject(userState)
                }
            }
        }
    }
}
