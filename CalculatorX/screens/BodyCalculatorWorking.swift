//
//  BodyCalculatorWorking.swift
//  CalculatorX
//
//  Created by Hau Nguyen on 14/09/2022.
//

import SwiftUI

struct BodyCalculatorWorking: View {
    @ObservedObject var viewModel: CalculationViewModel
    @ObservedObject var currencyViewModel: CurrencyViewModel
    @State private var expanded: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    @State private var isPresentedFrom: Bool = false
    @State private var isPresentedTo: Bool = false
    
    var spellOutView: some View {
        HStack(alignment: .top, spacing: UIScreen.getUnit(10)) {
            Button(action: { }) {
                Image(ImageStyle.name.speaker)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(self.colorScheme == .dark ? .white : .black)
                    .frame(width: UIScreen.getUnit(20), height: UIScreen.getUnit(20))
            }

            HStack {
                Text(String(self.viewModel.currentNumberSpell).spellOut())
                    .font(.regular(size: 16))
                    .foregroundColor(self.colorScheme == .dark ? .white : .black)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)
                    .frame(height: UIScreen.getUnit(30), alignment: .top)
                
                Spacer()
                
                Button(action: {
                    UIScreen.showAlert(title: "Đánh vần", msg: String(self.viewModel.currentNumberSpell).spellOut(), button: "OK")
                }) {
                    Text("Xem")
                        .font(.medium(size: 14))
                        .foregroundColor(.blue)
                }
            }
        }
    }
    
    var exchangeCurrency: some View {
        VStack(alignment: .center, spacing: UIScreen.getUnit(10)) {
            HStack(alignment: .center, spacing: 0) {
                                
                FunctionMoreButtonText(string: self.currencyCodeLeft) {
                    self.isPresentedFrom = true
                }
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .center, spacing: 0) {
                    
                    Text("Sang")
                        .font(.regular(size: 12))
                        .foregroundColor(Color.OviLight)
                        .fixedSize(horizontal: true, vertical: false)
                        .lineLimit(1)
                    
                    Image(ImageStyle.name.nextIcon)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.OviLight)
                        .frame(width: UIScreen.getUnit(20),
                               height: UIScreen.getUnit(20))
                }
                .frame(maxWidth: .infinity)
                                
                FunctionMoreButtonText(string: self.currencyCodeRight) {
                    self.isPresentedTo = true
                }
                .frame(maxWidth: .infinity)
                
            }
            
            Button(action: {
                self.viewModel.currentNumberSpell = String(format: "%.3f", self.totalResultExchange)
            }) {
                Text(self.totalResultExchangeShow + " " + self.currencyCodeRight)
                    .font(.medium(size: 18))
                    .foregroundColor(.yellow)
                    .fixedSize(horizontal: true, vertical: false)
                    .lineLimit(1)
                    .softOuterShadow()
            }
            
        }
        .sheet(isPresented: $isPresentedFrom) {
            ListViewSelectionRate(data: self.currencyViewModel.currencies, itemSelected: self.$currencyViewModel.fromCurrency, isPresented: $isPresentedFrom)
        }
        .sheet(isPresented: $isPresentedTo) {
            ListViewSelectionRate(data: self.currencyViewModel.currencies, itemSelected: self.$currencyViewModel.toCurrency, isPresented: $isPresentedTo)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            self.spellOutView
            
            Spacer()
            
            VStack(spacing: UIScreen.getUnit(15)) {
                HStack {
                    Text(TextDictionary.ExchangeRate + ":")
                        .font(.boldItalic(size: 16))
                        .foregroundColor(.OviLight)

                    Spacer()

                }
                
                self.exchangeCurrency
            }
            
            Spacer()
        }
        .padding(.top, UIScreen.getUnit(10))
        .padding(.bottom, -UIScreen.getUnit(10))
        .padding(.horizontal, UIScreen.getUnit(20))
        .frame(maxWidth: UIScreen.width, alignment: .leading)
        
    }
    
    var totalResultExchange: Double {
        let resultValue = self.viewModel.resultValue
        let unit = MTUtils.unitCurrency(from: self.currentRateLeft, to: self.currentRateRight)
        let result = resultValue * unit
        return result
    }
    
    var totalResultExchangeShow: String {
        let result = self.totalResultExchange
        return String(result).numberFormatted()
    }
    
    var currencyLeft: String {
        return self.currencyViewModel.fromCurrency?.currencyName ?? TextDictionary.SpaceDivider
    }
    
    var currentcyRight: String {
        return self.currencyViewModel.toCurrency?.currencyName ?? TextDictionary.SpaceDivider
    }
    
    var currentWorkingShow: String {
        let string = self.viewModel.workings
        return string.spellOut()
    }
    
    var currencyNameFrom: String {
        return self.currencyViewModel.fromCurrency?.currencyName ?? TextDictionary.SpaceDivider
    }
    
    var currencyNameTo: String {
        return self.currencyViewModel.toCurrency?.currencyName ?? TextDictionary.SpaceDivider
    }
    
    var currencyCodeLeft: String {
        return self.currencyViewModel.fromCurrency?.currencyCode ?? ""
    }
    
    var currencyCodeRight: String {
        return self.currencyViewModel.toCurrency?.currencyCode ?? ""
    }
    
    var currentRateLeft: Double {
        return self.currencyViewModel.fromCurrency?.currencyRate ?? 0
    }
    
    var currentRateRight: Double {
        return self.currencyViewModel.toCurrency?.currencyRate ?? 0
    }
}

struct BodyCalculatorWorking_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
            .colorScheme(.light)
    }
}
