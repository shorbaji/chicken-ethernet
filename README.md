# chicken-ethernet
Ethernet frame parsing for chicken scheme.

A pure scheme ethernet frame parser/unparser.

Provides an ethernet frame data structure (destination MAC, source MAC, 802.1q, ethertype and payload). Also provides read-ethernet-frame function which reads an ethernet frame and creates an ethernet frame data structure as well as the inverse write-ethernet-frame function.
