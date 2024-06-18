//
//  DeviceModel.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/16/24.
//

import Foundation
import CoreBluetooth

class DeviceModel: NSObject, ObservableObject, CBPeripheralDelegate {
    @Published var name: String?
    @Published var uuid: UUID?
    @Published var isConnected: Bool = false
    @Published var batteryLevel: Int = 0 {
        didSet {
            print("Battery level updated to \(batteryLevel)%")
        }
    }
    private var peripheral: CBPeripheral?
    private var services: [CBService] = []
    private var characteristics: [CBUUID: CBCharacteristic] = [:]
    private var serviceUUIDs: [CBUUID]?

    init(name: String? = nil, uuid: UUID? = nil, peripheral: CBPeripheral? = nil, serviceUUIDs: [CBUUID]? = nil) {
        self.name = name
        self.uuid = uuid
        self.peripheral = peripheral
        self.serviceUUIDs = serviceUUIDs
        super.init()
        self.peripheral?.delegate = self
    }

    func connect() {
        isConnected = true
        if let serviceUUIDs = serviceUUIDs {
            peripheral?.discoverServices(serviceUUIDs)
        } else {
            peripheral?.discoverServices(nil)
        }
        print("Connecting to the device and discovering services")
    }

    func disconnect() {
        isConnected = false
        print("Disconnecting from the device")
    }

    // MARK: - CBPeripheralDelegate

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        self.services = services
        print("Discovered services:")
        for service in services {
            print("Service UUID: \(service.uuid)")
            if service.uuid == CBUUID(string: "19B10000-E8F2-537E-4F6C-D104768A1214") {
                print("Main service for audio streaming discovered")
            } else if service.uuid == CBUUID(string: "180F") {
                print("Standard BLE Battery Service discovered")
            }
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        print("Discovered characteristics for service \(service.uuid):")
        for characteristic in characteristics {
            self.characteristics[characteristic.uuid] = characteristic
            print("Characteristic UUID: \(characteristic.uuid)")
            if characteristic.uuid == CBUUID(string: "19B10001-E8F2-537E-4F6C-D104768A1214") {
                print("Audio data characteristic discovered")
            } else if characteristic.uuid == CBUUID(string: "19B10002-E8F2-537E-4F6C-D104768A1214") {
                print("Codec type characteristic discovered")
            } else if characteristic.uuid == CBUUID(string: "2A19") {
                print("Battery Level characteristic discovered")
            }
            if characteristic.properties.contains(.read) {
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let value = characteristic.value {
            print("Updated value for \(characteristic.uuid): \(value)")
            if characteristic.uuid == CBUUID(string: "19B10002-E8F2-537E-4F6C-D104768A1214") {
                if let codecType = value.first {
                    switch codecType {
                    case 0:
                        print("Codec type: PCM 16-bit, 16kHz, mono")
                    case 1:
                        print("Codec type: PCM 8-bit, 16kHz, mono")
                    case 10:
                        print("Codec type: Mu-law 16-bit, 16kHz, mono")
                    case 11:
                        print("Codec type: Mu-law 8-bit, 16kHz, mono")
                    case 20:
                        print("Codec type: Opus 16-bit, 16kHz, mono")
                    default:
                        print("Unknown codec type")
                    }
                }
            } else if characteristic.uuid == CBUUID(string: "2A19") {
                if let batteryLevel = value.first {
                    print("Battery Level: \(batteryLevel)%")
                    self.batteryLevel = Int(batteryLevel) // Update the battery level property
                }
            }
        }
    }

    func writeValue(data: Data, to characteristic: CBCharacteristic) {
        peripheral?.writeValue(data, for: characteristic, type: .withResponse)
    }

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error writing value for characteristic \(characteristic.uuid): \(error.localizedDescription)")
            return
        }
        print("Successfully wrote value for characteristic \(characteristic.uuid)")
    }
}
