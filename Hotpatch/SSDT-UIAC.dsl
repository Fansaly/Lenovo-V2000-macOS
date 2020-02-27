// USBInjectAll.kext port configuration for Lenovo Z50-70/Z40-70 laptops

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock ("", "SSDT", 2, "hack", "UIAC", 0)
{
#endif
    // Override for USBInjectAll.kext
    Device(UIAC)
    {
        Name(_HID, "UIA00000")
        Name(RMCF, Package()
        {
            // EHC1 is disabled
            // XHC overrides
            "8086_9c31", Package()
            {
                // "port-count", Buffer() { 0x0d, 0, 0, 0},
                "ports", Package()
                {
                    "HS01", Package() // USB2 right
                    {
                        "UsbConnector", 0,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                    "HS02", Package() // USB3 left
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    "HS03", Package() // USB2 left
                    {
                        "UsbConnector", 0,
                        "port", Buffer() { 3, 0, 0, 0 },
                    },
                    "HS04", Package() // Card Reader
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 4, 0, 0, 0 },
                    },
                    "HS06", Package() // Webcam
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 6, 0, 0, 0 },
                    },
                    "HS07", Package() // Bluetooth
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 7, 0, 0, 0 },
                    },
                },
            },
        })
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF
