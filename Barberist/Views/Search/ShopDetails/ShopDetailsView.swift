//
//  ShopDetailsView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/24/25.
//

import SwiftUI
import MapKit

@MainActor
final class ShopDetailsViewModel: ObservableObject {
    @Published var shop: Shop
    @Published var specialists: [Specialist]
    @Published var services: [String]
    @Published var reviews: [Review]
    @Published var workingHours: [WorkingHour]
    @Published var mapRegion: MKCoordinateRegion
    @Published var nearbyShops: [Shop]
    
    init(shop: Shop, allShops: [Shop]) {
        self.shop = shop
        self.specialists = Specialist.mocks
        self.services = ["Soch olish", "Soqol olish", "Yuzni parvarishlash", "Kuyov"]
        self.reviews = Review.mocks
        self.workingHours = WorkingHour.mocks
        self.mapRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: shop.lat ?? 41.3111, longitude: shop.long ?? 69.2797),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        // Yaqin atrofdagi shoplar (masalan, 100km radius ichida va o‘zidan tashqari)
        self.nearbyShops = allShops
            .filter { $0.id != shop.id && ($0.distance ?? 999999) < 100_000 }
            .sorted { ($0.distance ?? 999999) < ($1.distance ?? 999999) }
    }
}
// MARK: - UI
struct ShopDetailsView: View {
    @ObservedObject var viewModel: ShopDetailsViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                mainImageSection
                shopHeaderSection
                specialistsSection
                servicesSection
                infoSection
                mapSection
                reviewsSection
                if !viewModel.nearbyShops.isEmpty {
                    nearbyShopsSection
                } else {
                    Text("Yaqin atrofda")
                        .font(.system(size: 18).bold())
                        .padding(.leading)
                    EmptySectionView(iconName: "mappin.slash.circle",
                                     title: "Atrofda yaqin barbershoplar topilmadi",
                                     subtitle: "Joylashuvga yaqinroq joyda urinib ko‘ring.")
                    .padding(.bottom)
                }
//                orderButton
                MainButton(title: "Buyurtma berish", isDisabled: false, action: {  })
                    .padding(.bottom, 32)
            }
            .padding(.bottom, 24)
            .frame(maxWidth: .infinity)
        }
        .toolbar(.hidden, for: .navigationBar)
        .background(Color.myBackground)
        .scrollIndicators(.hidden)
    }
    
    // MARK: Main Image & Title
    private var mainImageSection: some View {
        Image(viewModel.shop.image ?? "testImage")
            .resizable()
            .scaledToFill()
            .frame(width: .screenWidth, height: 250)
            .overlay() {
                VStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "arrow.backward")
                                .padding(10)
                                .background(Color.white.opacity(0.8))
                                .clipShape(Circle())
                        }
                        Spacer()
                        Button {
                            // to open gallery
                        } label: {
                            Image(systemName: "ellipsis")
                                .padding(10)
                                .background(Color.white.opacity(0.8))
                                .clipShape(Circle())
                        }
                    }
                    .foregroundStyle(.primary)
                    .padding(.horizontal)
                    .padding(.top, 24)
                    Spacer()
                }
            }
    }
    
    // MARK: Header Section (name, status, rating, orders, address)
    private var shopHeaderSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.shop.name ?? "")
                .font(.system(size: 24).weight(.semibold))
            Text("Ochiq")
                .font(.callout.weight(.semibold))
                .padding(8)
                .background(Color.green.opacity(0.1))
                .foregroundColor(.green)
                .cornerRadius(4)
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    HStack(spacing: 2) {
                        Text(String(format: "%.1f", viewModel.shop.rating ?? 0))
                            .font(.callout.weight(.semibold))
                            .padding(.trailing, 2)
                        ForEach(0..<5) { idx in
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 14, height: 14)
                                .foregroundColor((viewModel.shop.rating ?? 0) >= Double(idx+1) ? .accentColor : .gray.opacity(0.3))
                        }
                    }
                    Text("Buyurtma: \(viewModel.shop.ordersCount ?? 0)")
                        .font(.callout).foregroundColor(.secondary)
                }
                HStack(spacing: 4) {
                    Image(.pinItemIcon)
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text(viewModel.shop.address ?? "Shayxontohur, Tashkent")
                        .font(.subheadline)
                    Image(systemName: "location")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .padding(.leading)
                    Text(viewModel.shop.distance?.formattedDistance ?? "0 km")
                        .font(.callout)
                    Spacer()
                }
                .foregroundStyle(.secondary)
            }
        }
        .padding([.horizontal, .bottom])
        .padding(.top, 8)
        .background(Color.contentBackground)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    // MARK: Specialists
    private var specialistsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Mutaxassislar")
                .font(.system(size: 18).bold())
                .padding([.top, .leading])
            ScrollView(.horizontal) {
                HStack(spacing: 16) {
                    ForEach(viewModel.specialists) { specialist in
                        VStack(spacing: 4) {
                            Image(specialist.image ?? "testImage")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 90, height: 90)
                                .clipShape(Circle())
                            Text(specialist.name ?? "Name")
                                .font(.subheadline.weight(.semibold))
                                .padding(.top, 4)
                            HStack(spacing: 2) {
                                Image(systemName: "star.fill")
                                    .font(.caption)
                                Text(String(format: "%.1f", specialist.rating ?? "0.0"))
                                    .font(.system(size: 14).weight(.semibold))
                            }
                            .foregroundStyle(Color.accentColor)
                        }
                        .padding()
                        .frame(width: 131, height: 164)
                        .background(Color.contentBackground)
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                        .padding(.vertical, 4)
                    }
                }
                .padding(.leading)
            }
        }
    }
    
    // MARK: Services
    private var servicesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Xizmatlar")
                .font(.system(size: 18).bold())
            VStack(alignment: .leading, spacing: 8) {
                Text("O’zingiz uchun mos xizmatlarni tanlab buyurtma berishingiz mumkin")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .padding(.bottom)
                ForEach(viewModel.services, id: \.self) { service in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(service)
                            .font(.system(size: 18))
                        Divider()
                    }
                }
            }
            .padding()
            .background(Color.contentBackground)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .padding()
    }
    
    // MARK: Info
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ma'lumot")
                .font(.system(size: 18).bold())
            VStack(alignment: .leading, spacing: 8) {
                Text("Lorem ipsum dolor sit amet consectetur. Consectetur dolor egestas velit dolor dui morbi volutpat. Cursus faucibus purus eget facilisi nisl. Eget luctus mattis sem at vitae non dui nunc posuere. Sit est consectetur ")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .padding(.bottom)
                ForEach(viewModel.workingHours) { wh in
                    VStack(spacing: 8) {
                        HStack {
                            Text(wh.day ?? "")
                                .foregroundColor(wh.isToday ?? false ? .accentColor : .secondary)
                            Spacer()
                            Text(wh.hours ?? "")
                                .foregroundColor(wh.isToday ?? false ? .accentColor : .secondary)
                        }
                        .font(.system(size: 14))
                        Divider()
                    }
                }
            }
            .padding()
            .background(Color.contentBackground)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .padding()
        
    }
    
    // MARK: Map Section
    private var mapSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Qo'shimcha ma'lumotlar")
                .font(.system(size: 18).bold())
            VStack(alignment: .leading) {
                Map(initialPosition: .region(viewModel.mapRegion)) {
                    if let lat = viewModel.shop.lat, let long = viewModel.shop.long {
                        Marker(viewModel.shop.name ?? "Shop", coordinate: .init(latitude: lat, longitude: long))
                    }
                }
                .frame(height: 165)
                .cornerRadius(8)
                Text(viewModel.shop.address ?? "Shayxontohur, Tashkent")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .padding(.vertical, 4)
                Button {
                    // to open in map
                } label: {
                    Text("Xarita orqali ko‘rish")
                        .font(.system(size: 14).bold())
                        .foregroundColor(.accentColor)
                }
            }
            .padding()
            .background(Color.contentBackground)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .padding()
    }
    
    // MARK: Reviews
    private var reviewsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Izohlar")
                .font(.system(size: 18).bold())
            ForEach(viewModel.reviews) { review in
                ReviewCardView(review: review)
                    .padding(.bottom, 24)
            }
        }
        .padding([.horizontal, .top])
    }
    
    // MARK: Nearby Shops
    private var nearbyShopsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Yaqin atrofda")
                .font(.system(size: 18).bold())
                .padding(.leading)
            if viewModel.nearbyShops.isEmpty {
                EmptySectionView(iconName: "mappin.slash.circle",
                                 title: "Atrofda yaqin barbershoplar topilmadi",
                                 subtitle: "Joylashuvga yaqinroq joyda urinib ko‘ring.")

            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.nearbyShops) { shop in
                            ShopCardView(barbershop: shop)
                                .frame(width: 180)
                        }
                    }
                    .padding(.leading)
                }
            }
        }
        .padding(.bottom)
    }
    
    // MARK: Order Button
    private var orderButton: some View {
        Button(action: {
            // to order action
        }, label: {
            Text("Buyurtma berish")
                .font(.callout.weight(.semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .cornerRadius(4)
        })
        .padding()
    }
}




#Preview {
    ShopDetailsView(viewModel: ShopDetailsViewModel(shop: Shop.mock, allShops: HomeViewModel().allShopsWithDistance))
}


struct ReviewCardView: View {
    let review: Review

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack(alignment: .top, spacing: 10) {
                Image(review.image ?? "testImage")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 2) {
                    Text(review.name ?? "No name")
                        .font(.system(size: 16, weight: .semibold))
                    Text(review.dateString ?? "No date")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
                    .foregroundColor(.secondary)
                    .padding(.top, 2)
            }
            // Rating row
            HStack(spacing: 2) {
                ForEach(0..<5) { idx in
                    Image(systemName: idx < Int(review.rate ?? 0) ? "star.fill" : "star")
                        .font(.system(size: 14))
                        .foregroundColor(idx < Int(review.rate ?? 0) ? .accentColor : .secondary.opacity(0.5))
                }
            }
            // Review text
            Text(review.comment ?? "")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(Color.contentBackground)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}
