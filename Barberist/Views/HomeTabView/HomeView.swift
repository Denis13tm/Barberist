//
//  HomeView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/2/25.
//

import SwiftUI
import Combine

final class HomeViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var myOrdersTitle: String = ""
    @Published var nearbyShopTitle: String = ""
    @Published var topRatedShopTitle: String = ""
    @Published var ordinaryShopTitle: String = ""
    @Published var topReviewsTitle: String = ""
    
    @Published var barbershops: [BarbershopModel] = []
    @Published var myOrders: [OrderModel] = []
    @Published var topReviews: [ReviewModel] = []

    init() {
        // Bu yerda kelajakda API chaqirish yoki state tayyorlash bo'ladi
        loadHomeViewData()
    }
    
    func loadHomeViewData() {
        self.isLoading = true
        self.myOrdersTitle = "My Orders"
        self.nearbyShopTitle = "Nearby Barbershops"
        self.topRatedShopTitle = "Top Rated"
        self.ordinaryShopTitle = "Ordinary"
        self.topReviewsTitle = "Top Reviews"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.barbershops = (0..<20).map {
                BarbershopModel(name: "Salon \($0)", rating: 4.5, distance: "1.\($0) km", location: "Shayxontohur, Tashkent", imageName: "testImage")
            }
            self.myOrders = (0..<20).map {
                OrderModel(imageName: "testImage", name: "Ganzo Feruz \($0)", status: "Active", price: "45 000 UZS", serviceCount: "2 services", date: "Sun, 12 May, 4:45 PM")
            }
            self.topReviews = (0..<5).map {
                ReviewModel(imageName: "testImage", name: "Dave Jonson \($0)", shopName: "Fayz Shop", rateImage: "star_icon", rate: "5")
            }
            self.isLoading = false
        }
    }
}

//MARK: - UI
struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 16) {
                MyOrderView()
                NearbyShopView()
                TopRatedShopView()
                OrdinaryShopView()
                TopReviewsView()
            }
            .padding(.top, 24)
            .padding(.bottom, 54)
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationShadow()
        .toolbar { toolBarContent() }
        .background(Color.mainBackground)
        .refreshable {
            viewModel.loadHomeViewData()
        }
        
    }
    
    // MARK: - Subviews methods.
    @ToolbarContentBuilder
    private func toolBarContent() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Text("Barberist")
                .font(.system(size: 24, weight: .semibold))
        }
        ToolbarItem(placement: .topBarTrailing) {
            NavigationLink(destination: NotificationView()) {
                Image(.bellicon)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.black)
            }
        }
    }
}

//MARK: - Horizontal Card View

struct MyOrderView: View {
    @ObservedObject var viewModel = HomeViewModel()
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.myOrdersTitle)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.primary)
                .padding(.horizontal)
            if viewModel.isLoading {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(0..<5, id: \.self) { _ in
                            HorizontalCardPlaceholder()
                        }
                    }
                    .padding(.horizontal)
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.myOrders) { order in
                            NavigationLink(destination: Text("Card Details \(order.name)")) {
                                OrderCardView(order: order)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct OrderCardView: View {
    let order: OrderModel
    
    var body: some View {
        HStack(spacing: 8) {
            Image(order.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 110)
                .clipped()
            VStack(alignment: .leading, spacing: 4) {
                Text(order.name)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                Text(order.status)
                    .font(.caption)
                    .foregroundColor(.accentColor)
                HStack(spacing: 8) {
                    Text(order.price)
                        .font(.caption)
                        .foregroundColor(.accentColor)
                    Text(order.serviceCount)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Text(order.date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer()
        }
        .frame(height: 110)
        .frame(width: 344)
        .background(Color.contentBackground)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        .padding(.vertical, 8)
    }
}

//MARK: - Vertical Card Views

struct NearbyShopView: View {
    @ObservedObject var viewModel = HomeViewModel()
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.nearbyShopTitle)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.primary)
                .padding(.horizontal)
            if viewModel.isLoading {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(0..<5, id: \.self) { _ in
                            VerticalCardPlaceholder()
                        }
                    }
                    .padding(.horizontal)
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.barbershops) { barbershop in
                            NavigationLink(destination: Text("Card Details \(barbershop.name)")) {
                                ShopCardView(barbershop: barbershop)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct TopRatedShopView: View {
    @ObservedObject var viewModel = HomeViewModel()
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.topRatedShopTitle)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.primary)
                .padding(.horizontal)
            if viewModel.isLoading {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(0..<5, id: \.self) { _ in
                            VerticalCardPlaceholder()
                        }
                    }
                    .padding(.horizontal)
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.barbershops) { barbershop in
                            ShopCardView(barbershop: barbershop)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct OrdinaryShopView: View {
    @ObservedObject var viewModel = HomeViewModel()
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.ordinaryShopTitle)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.primary)
                .padding(.horizontal)
            if viewModel.isLoading {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(0..<5, id: \.self) { _ in
                            VerticalCardPlaceholder()
                        }
                    }
                    .padding(.horizontal)
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.barbershops) { barbershop in
                            ShopCardView(barbershop: barbershop)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct ShopCardView: View {
    let barbershop: BarbershopModel
    var size: CardSize = .regular

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Image
            Image(barbershop.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: imageHeight)
                .clipped()

            VStack(alignment: .leading, spacing: 5) {
                // Name
                Text(barbershop.name)
                    .font(.system(size: nameFontSize, weight: .semibold))
                    .foregroundColor(.primary)

                // Rating & Distance
                HStack(spacing: 8) {
                    Image("star_icon")
                        .resizable()
                        .frame(width: 10, height: 10)
                    Text(String(format: "%.1f", barbershop.rating))
                    Image("mapSymbol_icon")
                        .resizable()
                        .frame(width: 10, height: 10)
                    Text(barbershop.distance)
                }
                .font(.caption)
                .foregroundStyle(.secondary)

                // Location
                HStack(spacing: 4) {
                    Image("pinItem_icon")
                        .resizable()
                        .frame(width: 10, height: 10)
                    Text(barbershop.location)
                        .lineLimit(1)
                }
                .font(.caption)
                .foregroundColor(.gray)
            }
            .padding(8)
        }
        .background(Color.contentBackground)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
        .frame(width: cardWidth)
        .padding(.bottom, 6)
    }

    // MARK: - Dynamic values
    private var imageHeight: CGFloat {
        switch size {
        case .compact: return 80
        case .regular: return 94
        case .large: return 120
        }
    }

    private var cardWidth: CGFloat {
        switch size {
        case .compact: return 150
        case .regular: return 178
        case .large: return 220
        }
    }

    private var nameFontSize: CGFloat {
        switch size {
        case .compact: return 14
        case .regular: return 16
        case .large: return 18
        }
    }
}

enum CardSize {
    case compact, regular, large
}

//MARK: - Review Label View

struct TopReviewsView: View {
    @ObservedObject var viewModel = HomeViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.topReviewsTitle)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.primary)
                .padding(.horizontal)
            if viewModel.isLoading {
                ForEach(0..<5, id: \.self) { _ in
                    ReviewCellPlaceholderView()
                }
            } else {
                ForEach(viewModel.topReviews) { review in
                    ReviewLabelView(review: review)
                }
            }
        }
    }
}

struct ReviewLabelView: View {
    let review: ReviewModel

    var body: some View {
        HStack {
            Image(review.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 6) {
                Text(review.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                Text(review.shopName)
                    .font(.caption)
                    .foregroundColor(.secondary)
                HStack(spacing: 0) {
                    ForEach(0..<5) { _ in
                        Image(review.rateImage)
                    }
                    Text(review.rate)
                        .font(.caption.bold())
                        .foregroundStyle(Color.accentColor)
                        .padding(.leading, 4)
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 13))
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(Color.contentBackground)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        .padding(.horizontal)
        
    }
}

#Preview {
    HomeView()
}
#Preview {
    OrderCardView(order: OrderModel(imageName: "testImage", name: "Ganzo Firoz", status: "Active", price: "45 000 UZS", serviceCount: "2 services", date: "Sun, 12 May, 4:45 PM"))
}

