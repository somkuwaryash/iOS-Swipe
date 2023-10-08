//
//  AddProductView.swift
//  assignment
//
//  Created by Yash Somkuwar on 07/10/23.
//

import SwiftUI

struct AddProductView: View {
    @State private var productName: String = ""
    let productTypes = ["Electronic", "Machines", "Food"]
    @State private var productType: String = "Electronic"
    @State private var price: String = ""
    @State private var tax: String = ""
    // for selected image
    @State private var image: UIImage? = nil
    // for display of image picker
    @State private var isImagePickerShown: Bool = false
    // for feedback message
    @State private var feedbackMessage: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                //Section for inputting product details
                Section(header: Text("Product Details")
                            .font(.headline)
                            .foregroundColor(Color.primaryText)
                            .frame(maxWidth: .infinity)
                ) {
                    
                    TextField("Product Name", text: $productName)
                    Picker("Product Type", selection: $productType) {
                        ForEach(productTypes, id: \.self) {
                            Text($0).foregroundColor(Color.blue)
                        }
                    }
                    .foregroundColor(Color.secondary)
                    .background(Color.cardBackground)

                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)

                    TextField("Tax (%)", text: $tax)
                        .keyboardType(.decimalPad)

                    Button("Select Image") {
                        isImagePickerShown = true
                    }
                    .foregroundColor(Color.blue)

                    if let img = image {
                        Image(uiImage: img)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                    }
                }
                // submit button
                Button(action: validateAndSubmit) {
                    Text("Submit Product")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(10)
            }
            .background(Color.background.ignoresSafeArea())
            .sheet(isPresented: $isImagePickerShown) {
                ImagePicker(image: $image, sourceType: .photoLibrary)
            }
            .alert(isPresented: Binding<Bool>(
                        get: { !self.feedbackMessage.isEmpty },
                        set: { _ in self.feedbackMessage = "" }
                    )) {
                Alert(title: Text("Feedback"),
                      message: Text(feedbackMessage),
                      dismissButton: .default(Text("OK")))
            }
            .navigationBarTitle("Add Product", displayMode: .inline)
        }
    }
    //validate func
    private func validateAndSubmit() {
        guard !productType.isEmpty,
              !productName.isEmpty,
              Double(price) != nil,
              Double(tax) != nil else {
            feedbackMessage = "Ensure all fields are correctly filled."
            return
        }
        
        let product = newProduct(
            productName: productName,
            productType: productType,
            price: Double(price) ?? 0.0,
            tax: Double(tax) ?? 0.0,
            imageData: image?.pngData()
        )
        submitProduct(product: product)
    }
    
    //submit func
    private func submitProduct(product: newProduct) {
        guard let url = URL(string: "https://app.getswipe.in/api/public/add") else {
            feedbackMessage = "Failed to create API endpoint."
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()

        let parameters = [
            "product_name": product.productName,
            "product_type": product.productType,
            "price": "\(product.price)",
            "tax": "\(product.tax)"
        ]

        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }

        if let imageData = product.imageData {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"files[]\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body as Data

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    feedbackMessage = "Error submitting product: \(error.localizedDescription)"
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        feedbackMessage = "Server responded with \(httpResponse.statusCode)."
                        return
                    }
                    
                    if let data = data {
                        do {
                            let response = try JSONDecoder().decode(ResponseObject.self, from: data)
                            feedbackMessage = response.message ?? "Unknown error occurred"
                        } catch {
                            print("Decoding failed: \(error)")
                            print("Received data: \(String(data: data, encoding: .utf8) ?? "No data")")
                            feedbackMessage = "Error decoding response: \(error.localizedDescription)"
                        }
                    } else {
                        feedbackMessage = "No data received from server."
                    }
                } else {
                    feedbackMessage = "Unknown server response."
                }
            }
        }.resume()
    }



}

struct AddProductView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductView()
    }
}

//extension Color {
//    static let primaryColor = Color(red: 74/255, green: 85/255, blue: 104/255)
//    static let backgroundColor = Color(red: 238/255, green: 241/255, blue: 247/255)
//}
//
//
