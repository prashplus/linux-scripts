# This material is not sponsored or endorsed by Cisco Systems, Inc. Cisco, Cisco Systems, CCIE and the CCIE Logo are trademarks of Cisco Systems, Inc. and its affiliates.   
  All Cisco products, features, or technologies mentioned in this document are trademarks of Cisco. This includes, but is not limited to, Cisco IOS®, Cisco IOS-XE®, and Cisco IOS-XR®. Within the body of this document, not every instance of the aforementioned trademarks are prepended with the symbols ® or TM as they are demonstrated above.   
  THE INFORMATION HEREIN IS PROVIDED ON AN “AS IS” BASIS, WITHOUT ANY WARRANTIES OR REPRESENTATIONS, EXPRESS, IMPLIED OR STATUTORY, INCLUDING WITHOUT LIMITATION, WARRANTIES OF NONINFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. 


# The original version of this document can be found at [neckercube.com](https://neckercube.com/index.php/2018/04/11/mind-map-for-ccie-ccnp-routing-switching). This document attempts to provide the configuration syntax for the vast majority of the topics you may encounter on the Cisco CCIE Routing & Switching version 5 lab exam, based on the official blueprint as of April 2018. No actual tasks or scenarios are included. Verification commands are also not included.


# CCIE RSv5 Lab Config [neckercube.com](https://neckercube.com/index.php/2018/04/11/mind-map-for-ccie-ccnp-routing-switching) v2018-04-11


## Link-Layer

### Interface

- Physical

	- P2P

		- HDLC

			- Default for synchronous serial interfaces:

				- encapsulation hdlc

		- PPP

			- Interface:

				- encapsulation ppp

			- Authentication

				- PAP

					- Authenticator Interface:

						- ppp authentication pap

					- Authenticating Peer Interface:

						- ppp pap sent-username NAME password PASS

				- CHAP

					- Interface:

						- ppp authentication chap

					- Optionally send a different username than the default router hostname:

						- ppp chap hostname NAME

				- Both:

					- Both need a global username and password set for the authenticating peer:

						- username USER password PASS

					- You can configure both PAP and CHAP with the same statement. The first method is tried first, then the second method is tried if the first method fails.

						- ppp authentication chap pap

			- Misc

				- LQM

					- Interface:

						- ppp quality PERCENT

				- Compression

					- Interface:

						- compress METHOD

				- Address Assignment

					- Peer Default IP

						- Server Interface:

							- peer default ip address IP

						- Client Interface:

							- ip address negotiated

					- Local Address Pool

						- Global:

							- ip address-pool local  
							  ip local pool NAME FIRST-IP LAST-IP

						- Interface:

							- peer default ip address pool NAME

						- Client Interface:

							- ip address negotiated

				- Peer Host / Neighbor Route

					- Interface:

						- no peer neighbor-route

				- Peer Default Route

					- Interface:

						- ppp ipcp route default

					- Typically configured on the client / CPE side

			- MLPPP

				- Logical Bundle:

					- interface multilink NUMBER  
					    ip address ADD MASK  
					    encapsulation ppp  
					    ppp multilink  
					    ppp multilink group NUMBER

				- Each Physical Member:

					- no ip address  
					  encapsulation ppp  
					  ppp multilink  
					  ppp multilink group NUMBER

				- Optional Minimum Links:

					- ppp multilink min-links NUM mandatory

			- PPPoE

				- Server

					- Local IP Pool:

						- ip local pool POOL1 START-IP END-IP

					- Loopback Interface for unnumbered virtual-template:

						- interface loopback NUM  
						    ip address IP MASK

					- Virtual-template:

						- interface virtual-template NUM  
						    ip unnumbered NUM  
						    peer default ip address pool POOL1  
						    mtu 1492  
						    ip tcp adjust-mss 1452

					- BBA Group:

						- bba-group pppoe NAME  
						    virtual-template NUM

					- Ethernet Interface:

						- pppoe enable group NAME

				- Client

					- Dialer Interface:

						- interface dialer NUM  
						    encapsulation ppp  
						    ip address negotiated  
						    mtu 1492  
						    ip tcp adjust-mss 1452  
						    dialer pool NUM

					- Ethernet Interface:

						- pppoe-client dial-pool-number NUM

	- Multi-Access

		- Ethernet

			- Speed

				- When set to auto, both speed and duplex are negotiated

			- Duplex

				- Duplex cannot be half when speed is 1000

- Logical

	- P2P

		- GRE

			- Basic:

				- interface tunnel NUM  
				    tunnel source INTERFACE/IP  
				    tunnel destination IP  
				    ip address IP MASK

			- Optional:

				- bandwidth KBPS  
				  keepalive  
				  tunnel key NUM  
				  ip mtu BYTES  
				  ip tcp mss BYTES  
				  tunnel path-mtu-discovery

			- You can use the keepalive function in conjunction with the backup interface feature to do reliable backup tunnels. Keepalive can be enabled on either or both ends.

			- Watch for tunnel recursion errors. The tunnel endpoints cannot be known to routing protocols running through the tunnel. Use AD or filtering so that the outside tunnel endpoints are not known to the routing protocol(s) inside the tunnel.

			- Drop out of order packets:

				- tunnel sequence-datagrams

		- IPinIP

			- interface tunnel NUM  
			    tunnel source INTERFACE/IP  
			    tunnel destination IP  
			    tunnel mode ipip  
			    ip address IP MASK

		- Dialer

			- interface dialer NUM  
			    mtu 1492  
			    encapsulation ppp  
			    ip address negotiated  
			    dialer pool NUM

		- Virtual-Template

			- All configuration commands that apply to serial interfaces can also be applied to virtual templates, except shutdown and dialer commands. It is not  recommended to explicitly assign an IP address  to a virtual template interface.

			- interface virtual-template NUM  
			    ip unnumbered INT  
			    encapsulation ppp

	- P2MP

		- mGRE

			- mGRE does not specify a tunnel destination, and requires a mapping solution like NHRP

			- interface tun NUM  
			    tun source IP/INT  
			    ip address IP MASK  
			    tunnel mode gre multipoint

	- Multi-Access

		- SVI

			- interface vlan NUM  
			    ip address IP MASK

		- BVI

			- Bridge Virtual interfaces can combine multiple links together on a router to make the router act like a switch.

			- bridge irb  
			  bridge NUM protocol ieee  
			  bridge NUM route ip  
			   interface bvi NUM  
			    ip address IP MASK  
			   interface INT  
			    no ip address  
			    bridge-group NUM

		- Fallback Bridging

			- When configured, a switch bridges together multiple VLANs (SVIs) or routed ports so that non-routable traffic can be forwarded (such as for legacy protocols).

			- bridge NUM protocol vlan-bridge int INT1  bridge-group NUM int INT2  bridge-group NUM

	- Loopback

		- interface loopback NUM  
		    ip address IP MASK

- Access switchport

	- VLAN static assignment

		- interface INT  
		    switchport access vlan NUM  
		    switchport mode access

	- Voice VLAN

		- interface INT  
		    switchport access vlan NUM  
		    switchport voice vlan NUM

		- Optionally set priority tag:

			- switchport voice vlan dot1p

	- VLAN dynamic assignment 802.1X

		- Enable 802.1X authentication globally on the switch:

			- dot1x system-auth-control

		- Set the switchport to static access mode:

			- interface INT  
			    switchport mode access

		- Set the VLAN based on the event. Events include failure, no response, and server events. Use no-response to configure a guest VLAN

			- authentication event no-response action authorize vlan NUM

		- Set the port authorization state to auto:

			- authentication port-control auto

		- Enable 802.1X Port Access Entity Authenticator:

			- dot1x pae authenticator

- Trunk switchport

	- Activation

		- Static

			- Switches supporting both ISL and 802.1Q must have the encapsulation specified first:

				- switchport trunk encapsulation dot1q

			- Set the port for unconditional trunking mode:

				- switchport mode trunk

		- DTP

			- Actively try to form a trunk:

				- switchport mode dynamic desirable

			- Form a trunk if the other side initiates:

				- switchport mode dynamic auto

			- The other side will initiate if it is set to a static trunk unless switchport nonegotiate is configured.

	- Encapsulation

		- 802.1Q

			- Switches that support both ISL and 802.1Q   
			  must be configured for 802.1Q encapsulation

				- switchport trunk encapsulation dot1q

			- Optionally configure the native VLAN:

				- switchport trunk native vlan NUM

	- Allowed VLANs

		- All VLANs are allowed on a trunk by default. You can permit and deny VLANs based on either a whitelist or blacklist action:

			- switchport trunk allowed vlan OPTIONS

			- switchport trunk pruning vlan OPTIONS

### Misc

- UDLD

	- Global

		- Global configuration enables UDLD on all fiber ports:

			- Normal Mode detects physical misconfiguration on fiber:

				- udld enable

			- Aggressive Mode also detects one-way traffic:

				- udld aggressive

		- Adjust the time between probe messages  on ports in the advertisement phase and determined to be bidirectional. Default 15s

			- udld message time SEC

	- Port

		- Per-port configuration enables UDLD on copper ports as well as fiber:

			- udld port [aggressive]

	- Re-Enable UDLD Disabled Ports

		- udld reset

- EtherChannel

	- PAgP

		- Initiate PAgP:

			- channel-group NUM mode desirable [non-silent]

		- Form PAgP EtherChannel if the other side initiates:

			- channel-group NUM mode auto [non-silent]

		- Optional non-silent keyword is used when the other end of the link MUST be a PAgP-capable device. Without the keyword, silent mode is run by default, which allows the individual ports to keep functioning if a PAgP EtherChannel is not formed (such as when connecting to an end device).

	- Static

		- channel-group NUM mode on

	- LACP

		- Initiate LACP:

			- channel-group NUM mode active

		- Form LACP EtherChannel if the other side initiates:

			- channel-group NUM mode passive

		- Optional Settings:

			- System Priority controls which device makes certain bundling decisions. Configured globally, lower is better:

				- lacp system-priority NUM

			- Port Priority controls which ports are active and which are hot standby. Configured on the interface, lower is better:

				- lacp port-priority NUM

			- Control the maximum number of active links on the port-channel interface. Other members will be in hot standby.

				- interface po NUM  
				    lacp max-bundle 1-8

	- Layer 2

		- Layer 2 is the default. Ensure the interface is configured as switchport before adding channel-group commands.

	- Layer 3

		- Create the Layer 3 EtherChannel interface first:

			- interface port-channel NUM  
			    no switchport  
			    ip address IP MASK

		- Member interfaces must be configured as Layer 3 before bundling into an EtherChannel:

			- no switchport  
			  no ip address  
			  channel-group NUM OPTIONS

	- EtherChannel Misconfig Guard

		- Enabled by default, a message is displayed if STP detects an EtherChannel misconfiguration. Disable globally:

			- no spanning-tree etherchannel guard misconfig

	- Load Balancing

		- Configured globally and applies to all EtherChannels:

		- port-channel load-balance METHOD

		- METHOD is platform dependent:

			- dst-ip

			- src-ip

			- dst-mac

			- src-mac

			- src-dst-ip

			- src-dst-mac

		- Regardless of the method, packets with the same set of information use the same links in the bundle. For example, if src-ip is chosen, all packets coming from the same source IP address will use the same link, so you would only use this method if you will have many different sources.

- Errdisable Recovery

	- Enable globally per-cause or for all causes:

		- errdisable recovery cause CAUSE

	- Optionally configure the timeout interval (300s default):

		- errdisable recovery interval NUM

- CDP

	- Disable globally:

		- no cdp run

	- Disable Per-Interface:

		- no cdp enable

	- Adjust global timers:

		- cdp timer SEC  
		  cdp holdtime SEC

- LLDP

	- Enable globally:

		- lldp run

	- Enable on the interface:

		- lldp transmit  
		  lldp receive

	- Optional global settings:

		- lldp holdtime SEC  
		  lldp timer SEC  
		  lldp tlv-select TLVs

- MAC Address Table

	- CAM Aging

		- mac address-table aging-time SEC vlan VLAN

	- Clear MAC entry

		- clear mac address-table dynamic MAC

	- Record MAC changes

		- mac address-table notification change

	- Create static MAC entry

		- mac address-table static MAC vlan VLAN interface INT

	- Static unicast MAC filtering

		- mac address-table static MAC vlan VLAN drop

- Layer 2 MTU

	- System-wide:

		- system mtu jumbo MTU  
		  reload

	- Routed ports and SVIs can be adjusted also, to prevent packet fragmentation. Even if the system MTU is set higher than 1500 bytes, routed packets will still be fragmented at 1500 bytes unless adjusted with the following command:

		- system mtu routing MTU

	- Per-VLAN:

		- vlan VLAN  mtu NUM

- SPAN

	- SPAN

		- Configure source:

			- monitor session NUM source SRC OPTIONS

			- SRC can be individual interfaces or a VLAN, but not both

			- OPTIONS include rx tx or both

			- You can also limit the capture to specific VLANs, or to  
			  specific criteria (known as Flow-Based SPAN or FSPAN). You cannot configure both of these features simultaneously.

			- monitor session NUM filter vlan VLANs

			- monitor session NUM filter {ip | ipv6 | mac} access-group ACL

		- Configure destination:

			- monitor session NUM destination DEST [encapsulation replicate]

			- DEST can be multiple ports

			- encapsulation replicate keeps 802.1Q tags

			- The destination port can also be configured to accept ingress traffic, such as when connecting to an IDS appliance, with the ingress keyword

	- RSPAN

		- Configure the RSPAN VLAN on all participating switches:

			- vlan NUM  
			    remote-span  
			    exit

		- Source:

			- monitor session NUM source SRC OPTIONS

			- SRC can be individual interfaces or a VLAN, but not both

			- You can also limit the capture to specific VLANs, or to specific criteria (known as Flow-Based RSPAN or FRSPAN). You cannot configure both of these features simultaneously.

			- OPTIONS include rx tx or both

			- monitor session NUM filter vlan VLANs

			- monitor session NUM filter {ip | ipv6 | mac} access-group ACL

		- RSPAN VLAN Destination:

			- monitor session NUM destination remote vlan VLAN

		- RSPAN VLAN Source:

			- monitor session NUM source remote vlan VLAN

		- Destination:

			- encapsulation replicate keeps 802.1Q tags

			- The destination port can also be configured to accept ingress traffic, such as when connecting to an IDS appliance, with the ingress keyword

	- ERSPAN

		- Source Session:

			- monitor session NUM type erspan-source  
			    source INT | VLAN [rx | tx | both]

			- Optional description and filter

			- destination  
			  ip address IP  
			  erspan-id ID  
			  origin ip address IP

			- Optional TTL, precedence, DSCP, and VRF

			- no shutdown

		- Destination Session:

			- monitor session NUM type erspan-destination  
			    destination INT

			- Optional description

			- source  
			  ip address IP  
			  erspan-id ID

			- Optional VRF

			- no shutdown

### VTP

- Domain

	- vtp domain NAME

- Authentication

	- When adding a new switch to the VTP domain, the password must match before any VTP advertisements are accepted.

		- vtp password PASS

	- VTPv3 can additionally use the hidden or secret keywords for encryption

- Version

	- vtp version {1 | 2 | 3}

- Mode

	- Server

		- vtp mode server

	- Transparent

		- When in transparent mode, VTP advertisements from other switches are still passed on when used with VTPv2 or v3, as long as the domain matches.

			- vtp mode transparent

	- Primary Server VTPv3

		- vtp primary-server vlan

	- Client

		- vtp mode client

	- Off

		- This mode is functionally the same as VTP Transparent mode, except VTP advertisements from other switches are never forwarded, regardless of version.

			- vtp mode off

		- With VTPv3, you can disable VTP per-trunk-port:

			- no vtp

- Pruning

	- VTP pruning is not designed to work with VTP Transparent mode. 

		- vtp pruning

### STP

- Classic STP

	- Root Bridge election

		- Bridge ID:

			- spanning-tree vlan VLAN priority NUM

		- Primary Macro:

			- spanning-tree vlan VLAN root primary

			- Optional diameter and hello-time parameters

			- This causes the priority to be set to 24576, or 4096   
			  less than the current root if it is lower than 24576.

		- Secondary Macro:

			- spanning-tree vlan VLAN root secondary

			- Sets the priority to 28672

			- Optional diameter and hello-time parameters

	- Root / Designated Ports

		- Path Cost

			- spanning-tree [vlan VLAN] cost NUM

			- Cost is added locally to received STP cost. Configure on local switch to influence path to upstream switch

		- Port Priority

			- spanning-tree [vlan VLAN] port-priority NUM

			- Configure on upstream switch to influence path on downstream switch

	- Timers

		- Hello

			- spanning-tree vlan VLAN hello-time SEC

		- Forward Delay

			- spanning-tree vlan VLAN forward-time SEC

		- MaxAge

			- spanning-tree vlan VLAN max-age SEC

	- Disable:

		- STP can be disabled on individual VLANs:

			- no spanning-tree vlan VLAN

- RSTP

	- Enable globally:

		- spanning-tree mode rapid-pvst

	- Link Type:

		- Link type is detected automatically based on operational duplex. If a port is operating at half-duplex but is a physical point-to-point, you can override it with this interface command.

			- spanning-tree link-type point-to-point

	- Other settings (like timers and BID) are configured identically to PVST

- MST

	- Enable globally:

		- spanning-tree mode mst

	- Region:

		- spanning-tree mst configuration  
		    instance NUM vlan VLANs  
		    name NAME  
		    revision NUM

	- Per-MST Instance Priority:

		- spanning-tree mst INSTANCE priority NUM

	- Root / Secondary:

		- spanning-tree mst INSTANCE root primary

		- spanning-tree mst INSTANCE root secondary

		- Optional diameter and hello-time parameters

	- Port Priority:

		- Configured at the port level:

			- spanning-tree mst INSTANCE port-priority NUM

	- Path Cost:

		- Configured at the port level:

			- spanning-tree mst INSTANCE cost NUM

	- Timers:

		- Hello

			- spanning-tree mst hello-time SEC

		- Forward Delay

			- spanning-tree mst forward-time SEC

		- MaxAge

			- spanning-tree mst max-age SEC

	- Hop Count:

		- The number of hops in a region before the BPDU is discarded. Default is 20.

		- spanning-tree mst max-hops NUM

	- Link Type:

		- Link type is detected automatically based on operational duplex. If a port is operating at half-duplex but is a physical point-to-point, you can override it with this interface command.

			- spanning-tree link-type point-to-point

- Misc

	- PortFast

		- Enable globally on all non-trunking ports:

			- spanning-tree portfast default

		- Enable per-port, including trunks:

			- spanning-tree portfast [trunk]

	- BPDU Guard

		- Enable globally on all ports using portfast:

			- spanning-tree portfast bpduguard default

		- Enable / Disable at the port level regardless of portfast:

			- spanning-tree bpduguard {enable | disable}

	- BPDU Filtering

		- Global:

			- Global configuration enables BPDU Filter on portfast-enabled ports. A few BPDUs are sent upon link-up, then BPDUs cease to be sent, and are not expected to be received. If BPDUs are received, the port loses portfast status and BPDU filtering is disabled.

				- spanning-tree portfast bpdufilter default

		- Per-Port:

			- Enabling directly at the port level effectively disables spanning-tree on that port.

				- spanning-tree bpdufilter {enable | disable}

	- Root Guard

		- Configured at the interface. Root Guard and Loop Guard are mutually exclusive.

			- spanning-tree guard root

	- Loop Guard

		- Configured globally. Root Guard and Loop Guard are mutually exclusive. Loop Guard only operates on interfaces considered to be P2P by STP.

			- spanning-tree loopguard default

		- Enabled per-interface:

			- spanning-tree guard loop

## IGP

### Protocol-Independent

- ARP

	- Static entry:

		- arp IP MAC arpa [INT]

		- Optional alias keyword (instead of INT) to respond to ARP requests for the IP address

		- Creating static entries might be necessary in the lab if proxy arp has been disabled

	- Change expiration time:

		- interface INT  
		    arp timeout SEC

		- Default 14400 (4 Hours)

	- Proxy ARP (in Security section)

	- ARP ACL (in Security section)

- Backup Interface

	- Allows you to have the same configuration on a single interface.

	- interface INT1  
	    <config>  
	    backup interface INT2  
	    
	  interface INT2  
	    <identical config INT1>

	- This includes logical interfaces such as GRE tunnels

	- You can also configure a delay under the backup interface configuration. The first value is the number of seconds after the main interface goes down before the backup interface goes active. The second value is how many seconds after the main link comes back up before the backup is deactivated.

	- backup delay START-SEC STOP-SEC

- Static Routing

	- Next-Hop (Recursive)

		- ip route PFX MASK NEXT-HOP-IP

		- If the next hop is not resolvable, the static route is not installed in the routing table

		- Recursive static routes are checked by default every 60 seconds and adjusted accordingly. This can be modified globally:

		- ip route static adjust-time SEC

	- Egress Interface

		- ip route PFX MASK EXIT-INT

	- Fully-specified

		- ip route PFX MASK EXIT-INT NEXT-HOP-IP

		- Use to prevent the route from going through an unintended interface

	- Floating Static

		- Adjust the distance to a higher value to make the static route present but less preferred than other routers

		- ip route PFX MASK <options> DISTANCE

	- Permanent

		- Keeps the static route in the routing table even if the interface shuts down

		- ip route PFX MASK <options> permanent

	- Reliable Static Routing with Object Tracking

		- Associate the static route with a tracked object and only install the route if the object is Up

		- ip route PFX MASK <options> track NUM

	- Tag

		- Assign a tag to the route for redistribution filtering

		- ip route PFX MASK <options> tag NUM

	- Name

		- Similar to an interface description, allows you to mark a route in the configuration for easier reading / understanding

		- ip route PFX MASK <options> name DESCRIPTION

	- VRF

		- ip route vrf NAME <options>

		- Specify that the next hop is in the global routing table:

		- ip route vrf NAME <options> global

- Default Routing

	- ip route 0.0.0.0 0.0.0.0

		- Can be redistributed into RIP and EIGRP but not OSPF or IS-IS (use default-information originate instead)

	- ip default-network

		- RIP advertises 0.0.0.0

		- EIGRP flags the network as candidate default and a route to the network must be in the routing table

	- ip default-gateway

		- Used when routing is disabled on the device

- Redistribution

	- Distribute-Lists

		- Filter routes based on referenced ACL under routing protocol process:

		- distribute-list ACL out [INT / PID / ASN]

		- OSPF cannot specify an interface, and the filter applies only to external routes

		- distribute-list ACL in [INT]

		- For OSPF and IS-IS, the routes are still in the database, but not in the RIB

	- Route-Maps

		- Feedback filter:

		- route-map EIGRP_TO_OSPF deny 10  
		   match ip address OSPF  
		  route-map EIGRP_TO_OSPF permit 20  
		    
		  route-map OSPF_TO_EIGRP deny 10  
		   match ip address EIGRP  
		  route-map OSPF_TO_EIGRP permit 20

	- Tag / Filter

		- route-map EIGRP_TO_OSPF deny 10  
		   match tag 110  
		  route-map EIGRP_TO_OSPF permit 20  
		   set tag 90

	- Administrative Distance

		- Configure under routing protocol process:

		- Ignore all routing updates for which a specific distance has not been set:

			- distance 255

		- Filter all routes from all sources matching the ACL:

			- distance 255 0.0.0.0 255.255.255.255 ACL

		- EIGRP example: set internal routes to 80 and external routes to 100:

			- distance eigrp 80 100

		- Set distance for individual route sources, where the optional ACL defines which routes will be affected from the specified source:

			- distance 200 10.10.10.0 0.0.0.255 [ACL]

		- Set one distance for individual IP, but a different distance for all other IPs in the same subnet. Processed top-down, put most-specific first:

			- distance 100 10.10.10.5 0.0.0.0  
			  distance 200 10.10.10.0 0.0.0.255

		- Remember during redistribution that a route's native protocol should be preferred within the particular routing domain.

	- Protocol Options

		- RIPv2

			- RIP automatically redistributes static routes with a metric of 1

		- EIGRP

			- Redistribution Prefix Limit is used under address-family configuration mode and is used primarily with VRFs.

			- router eigrp 100  
			    address-family ipv4 vrf VRF  
			      redistribute maximum-prefix <options>

		- OSPF

			- OSPF redistribution uses default metric 20 except for BGP, which is 1. When redistributing between OSPF processes, O and O IA routes  are redistributed as external with their metric set to the value at the redistribution point.

			- By default. routes redistributed into OSPF are Type 2

			- NSSA redistribution filtering using the nssa-only keyword causes the redistributed routes to have the P bit cleared and stay within the NSSA

			- Redistribution Prefix Limit with OSPF limits how many prefixes can be redistributed into the OSPF database in total, regardless of the route source:

				- redistirbute maximum-prefix <options>

			- Only OSPF internal routes are redistributed into other routing protocols by default. You can choose which routes to include with the match keyword when redistributing OSPF into other routing protocols.

		- BGP

			- iBGP routes are not redistributed into IGPs by default in the global routing table. It is the default for VRFs, though. Enable under the global BGP process:

			- bgp redistribute-internal

		- Common Options:

			- BGP, connected, static, EIGRP, ODR and RIP all support only metric and route-map options

			- OSPF and IS-IS support further matching of various route types (internal/E1/E2/N1/N2)

			- RIP, OSPF, and BGP use subtractive no redistribute, but EIGRP removes the entire redistribute command. For example, no redistribute static route-map RM1 will remove just the route-map RM1 portion but leave the redistribute static portion in place for RIP, OSPF, and BGP

			- Set a default metric to redistributed routes that do not have an explicit metric set. RIP and EIGRP require a metric to be set (or a default to be set) during redistribution:

			- default metric METRIC

	- Miscellaneous

		- Remember that RIP and EIGRP will not advertise routes that the local router cannot use (AD-based issues being the primary example, such as when RIP learns a RIP route from OSPF instead).

		- Create a redistribution chart with each point of redistribution (each router) as a row, and the routing protocols into which routes are being redistributed as columns, with separate permit and deny sub-columns.  Example, R1: permit all OSPF into RIP, deny all RIP native into RIP, permit all RIP into OSPF. R2: permit all connected into EIGRP ASN, deny nothing.

- PBR

	- Policy Routing

		- interface INT  
		    ip policy route-map NAME

		- The route-map can match on either or both:

			- match length MIN MAX  
			  match ip address ACL

		- Set commands, multiple can be issued default version processed after regular

			- set ip next-hop

			- set interface

		- When there is no specific route, useful to provide an alternate default route:

			- set ip default next-hop

			- set default interface

		- Packet enters VRF but needs to be policy routed to the global table:

			- set ip global next-hop IP

		- PBR applied within a VRF:

			- set ip vrf VRF next-hop IP

		- You can also set other attributes such as IP precedence

	- PBR with IP SLA

		- PBR based on tracked object:

		- ip sla NUM  
		    icmp-echo IP source-interface INT  
		    frequency SEC  
		  ip sla schedule NUM start-time now life forever  
		    
		  track NUM ip sla NUM state

		- route-map NAME  
		    match ip address ACL  
		    set ip next-hop verify-availability NXT-HOP SEQ track NUM

		- The route-map allows you to specify multiple next-hops in sequence to try based on availability

	- Local Policy Routing

		- Policy routes packets generated by the router

		- ip local policy route-map NAME

- On-Demand Routing

	- Only primary IP addresses are advertised

	- Enable on hub router:

		- router odr

	- Disable on individual interfaces by disabling CDP:

		- no cdp enable

	- Routes can be filtered with distribute-list

	- Timers can be adjusted:

		- timers basic <timers>

- BFD

	- Basic Configuration:

		- interface INT  
		    bfd interval MS min_rx MS multiplier NUM

		- Between two neighbors, the slower (larger) MS values are used when they differ

		- After basic configuration on interfaces, upper-layer protocols need to register

		- BFD control packets are UDP, sourced from 49152 and sent to 3784. BFD echo packet src/dst UDP 3785

	- BFD Template:

		- Configure intervals and authentication that do not apply to a single interface.

		- bfd-template {single-hop | multi-hop} NAME  
		    interval min-tx MS min-rx MS multiplier NUM  
		    authentication <options>  
		    dampening <options>  
		    echo

		- Apply to interface:

			- interface INT  
			    bfd template NAME

	- Multi-Hop BFD Map

		- Requires multihop template creation first

		- bfd map ipv4 DST/LEN SRC/LEN TEMPLATE

	- Echo mode

		- Enabled by default

		- Src/Dst IP is sending host  
		  Src MAC is sending host  
		  Dst MAC is receiving host

		- Echo packets are sent at negotiated rate  
		  Control packets are set by bfd slow-timers MS

	- Static Routing

		- Single-hop:  
		  You must specify the interface

		- ip route static bfd INT NEXT-HOP [unassociate]  
		  ip route PFX MASK INT NEXT-HOP

		- The unassociate keyword is used when the  BFD neighbor is not associated with a static route.

		- You can group static routes together, so that if the primary route becomes unavailable, the subordinate passive routes are also removed from the routing table:

		- ip route static bfd INT NEXT-HOP group NAME  
		  ip route static bfd INT NEXT-HOP2 group NAME passive

		- Multi-hop:  
		  You must NOT specify the interface

		- Configure multi-hop template and bfd map statements first

		- ip route static bfd DST-IP SRC-IP [unassociate]

	- RIPv2

		- Configured under RIP process:

			- bfd all-interfaces

		- Requires advertisement of routes other than the transit link for neighborship to form

	- EIGRP

		- Enabled under EIGRP process:

			- bfd all-interfaces

			- bfd INT

		- With EIGRP Named mode, it is configured under AF-Interface

	- OSPF

		- Can be enabled on the interface:

			- ip ospf bfd

		- Can be enabled under router ospf:

			- bfd all-interfaces

			- bfd INT

		- Can be disabled on the interface:

			- ip ospf bfd disable

	- BGP

		- Configured per-neighbor:

			- neighbor IP fall-over bfd

		- Multi-Hop: Configure multi-hop template and bfd map commands first

			- neighbor IP fall-over bfd multi-hop

	- HSRP

		- Configured on the interface:

			- standby bfd

		- Or configured globally:

			- standby bfd all-interfaces

	- PIM

		- Configured on the interface:

			- ip pim bfd

	- DMVPN

		- Apply to tunnel interface:

			- int tun NUM  
			    bfd interval MS min_rx MS multiplier NUM

### RIPv2

- Network assignment

	- RIP process:

		- network PFX

	- RIP network assignment is classful. If you enter 10.10.10.0, it is automatically converted to 10.0.0.0

- Passive Interface

	- RIP process:

		- passive-interface default

		- passive-interface INT

		- no passive-interface INT

	- When an interface has been configured as passive, multicast updates are no longer sent. However, the interface can still be configured for unicast updates with the neighbor IP command under the RIP process. This is unlike EIGRP, where an interface marked as passive does not send or process updates of any kind.

- Split Horizon

	- Interface:

		- no ip split-horizon

- Update Destination

	- Multicast

		- Default for RIPv2, 224.0.0.9

	- Broadcast

		- Interface:

			- ip rip v2-broadcast

	- Unicast

		- RIP process:

			- neighbor IP

		- Must be configured on both sides, unlike OSPF

		- Note that multicast updates are still sent unless the interface is marked passive. Likewise, the interface still listens for multicast RIP updates unless the interface is configured as passive.

- Send / Receive Version

	- RIP process:

		- Default is send v1, receive both

		- version {1 | 2}

	- Interface:

		- ip rip receive version [1] [2]

		- ip rip send version [1] [2]

- Authentication

	- Clear Text

		- Interface:

			- ip rip authentication mode text  
			  ip rip authentication key-chain NAME

	- MD5

		- Interface:

			- ip rip authentication mode md5  
			  ip rip authentication key-chain NAME

- Filtering

	- Prefix List

		- Remember to end prefix lists with permit 0.0.0.0/0 le 32 as a 'permit any'

		- distribute-list prefix PFX-LIST {in | out} [INT]

		- You can specify the source or destination of the updates with the gateway keyword

		- distribute-list prefix PFX1 gateway PFX2 {in | out}

	- ACL

		- distribute-list ACL {in | out}

		- Example, filter prefixes with even number in the third octet:

			- access-list 1 permit 0.0.1.0 255.255.254.255  
			  router rip  
			    distribute-list 1 in

		- Extended ACL:  source is update-source  
		  destination is network address

			- Example: allow only network 10.10.1.0 from host 20.20.20.1:

			- access-list 100 permit ip host 20.20.20.1 host 10.10.1.0

	- Offset List

		- Set to 16 to filter

		- offset-list ACL {in | out} 16 [INT]

	- AD

		- RIP cannot advertise routes it does not use itself, so setting their distance to 255 effectively filters them from RIP

		- distance 255 IP WC ACL

		- Where IP and Wildcard are the update source(s), and ACL references the routes to filter (matching based on permit)

		- You can perform this filtering per-neighbor  
		  by specifying the IP with a WC of 0.0.0.0:

			- distance 255 NEIGHBOR-IP 0.0.0.0 ACL

- Offset List

	- Adds metric to routes learned via RIP

	- offset-list ACL {in | out} OFFSET [interface]

- Summarization

	- Auto

		- Enabled by default. Disable under RIP process

			- no auto-summary

	- Manual

		- Interface:

			- ip summary-address rip PFX MASK

			- Only the summary is advertised. The specifics are suppressed.

- Timers

	- Configured under RIP process: Update, Invalid, Holddown, Flush values in seconds

		- timers basic UPD INV HLD FLSH

	- Per-interface:

		- ip rip advertise SEC

	- Timers can be adjusted per-VRF:

		- router rip  
		    address-family ipv4 vrf VRF  
		      timers basic 1 2 3 4

- Triggered Updates

	- Causes RIP updates to be sent only when necessary

	- Interface:

		- ip rip triggered

- Default Routing

	- Default

		- Routing process:

			- default-information originate

		- Enable on passive interfaces only:

			- default-information originate on-passive

	- Conditional Default

		- Generates default if route-map is satisfied. Must use standard ACL, not extended.

		- default-information originate route-map NAME

		- Example, match ACL, set interface, causes a default to be sent over the set interface if the match ACL is present in the routing table

		- Alternatively, to simply always advertise a default out of only specific interfaces, use no match statements, and set interface

	- Reliable Conditional Default

		- Create IP SLA

		- Create tracked object referencing it

		- Create dummy static route to null0 referencing tracked object

		- Create prefix-list permitting the dummy route

		- Reference prefix-list in route-map

		- Originate with route-map under RIP

		- Full example:

		- ip sla 1  
		    frequency 5  
		    icmp-echo DST-IP  
		  ip sla schedule 1 start now life forever  
		  track 1 ip sla 1  
		    
		  ip route 169.254.0.1 255.255.255.255 Null0 track 1  
		  ip prefix-list DUMMY permit 169.254.0.1/32  
		  route-map NAME  
		    match ip address prefix-list DUMMY  
		    
		  router rip  
		    default-information originate route-map NAME

- Update Source Validation

	- By default the router checks that the RIP update comes from an IP that is on the same network as one of the IP addresses on the receiving interface. This is necessary for ip unnumbered

	- Disable under the RIP process:

		- no validate-update-source

### EIGRP

- Basics

	- Router ID

		- Set manually under EIGRP process:

			- eigrp router-id IP

		- Named mode:

			- router eigrp NAME  
			    address-family ipv4 aut ASN  
			      eigrp router-id IP

		- Unlike OSPF, EIGRP can use the same router-id across multiple processes (ASNs)

	- Maximum Hops

		- EIGRP process or topology base:

			- metric maximum-hops NUM

		- Default 100

	- Passive Interface

		- Suppress updates and neighborships on an interface while still including it in the EIGRP topology

		- All interfaces:

			- passive-interface default

		- Select interfaces:

			- [no] passive-interface INT

	- Timers

		- Hello/Hold configured per-interface:

			- ip hello-interval eigrp ASN SEC

			- ip hold-time eigrp ASN SEC

		- Hello/Hold configured under AF-Interface:

			- hello-interval SEC

			- hold-time SEC

	- Split-Horizon

		- Enabled by default on all interfaces:

			- no ip split-horizon eigrp ASN

		- Configured under AF-interface in Named mode

	- Multicast / Unicast Neighbors

		- Multicast dynamic neighborship via network command:

			- network PFX WILDCARD

			- Enables EIGRP on all interfaces within the range  
			  that do not have unicast neighbors configured

		- Unicast configured under EIGRP process:

			- neighbor IP INT

			- This disables multicast neighborships on the specified interface. The interface must also not be set for passive. Unlike OSPF, the neighbor statement must be configured on both sides.

			- With unicast neighbors, you can specify a description:

			- neighbor IP description TEXT

	- Administrative Distance

		- EIGRP supports adjusting internal and external route AD under the EIGRP process and topology base:

			- distance eigrp INT EXT

	- Metrics

		- Variance

			- Allows for unequal-cost load distribution across feasible successors

			- EIGRP process:

				- variance MULTIPLIER

		- Offset List

			- EIGRP process:

				- offset-list ACL {in | out} NUM [INT]

		- Metric Weights

			- Toggle the K-values under EIGRP process:

				- metric weights TOS K1 K2 K3 K4 K5

			- TOS is always 0

			- Default is K1 and K3 = 1

		- Default Metric

			- During redistribution, a metric must be specified except for connected, static with exit interface, and other EIGRP processes. You can set a default metric to cover all the other cases.

			- default-metric BW DL RL LD MTU

		- Traffic Engineering

			- Adjust the interface delay parameter to influence path selection in EIGRP without modifying QoS parameters or using offset lists

	- Summarization / Default Routes

		- Auto-Summary

			- Disabled by default

			- Configured under EIGRP process and topology base for named mode:

				- auto-summary

		- Manual Summary

			- Interface:

				- ip summary-address eigrp ASN PFX MASK [AD]

			- The default local AD is 5 but can be adjusted. If set to 255, the summary is not advertised to the peer.

			- Both internal and external summaries will show in neighbor routing tables with an AD of 90 by default. Even though the summary may consist of external routes with an AD of 170, the summary itself is still considered an internal EIGRP route.

			- Only the summary is advertised. The specifics are suppressed.

			- Named mode configure under AF-interface

		- Summary Metric

			- A fixed metric prevents router churn due to the normal summary metric being recalculated every 5 minutes by default. EIGRP process:

			- summary-metric PFX MASK BW DL RL LD MTU [distance AD]

			- By setting the AD to 255, the summary route is still advertised, but not installed locally, referred to as poisoned floating summarization

		- Summarization with Default Routing

			- ip summary-address eigrp ASN 0.0.0.0 0.0.0.0

			- This advertises a default via EIGRP out of an interface at the expense of suppressing all other routes advertised out of the interface

		- Default Information

			- By default exterior default routes are accepted and are passed between EIGRP processes during redistribution. This can be controlled under the EIGRP process:

			- default-information {in | out} [ACL]

	- Stub

		- EIGRP stub bounds the query domain as query messages are not normally sent to EIGRP routers advertising the stub flag. You can adjust which information is advertised by the stub router, with connected and summary routes advertised by default.

		- EIGRP process:

			- eigrp stub [options]

			- receive-only option is standalone and cannot be used with any other option. This setting causes the router to be willing to participate in an EIGRP neighborship, but to not send any updates of its own. This is an alternative to prefix filtering.

			- connected is a default option

			- summary is a default option

			- static option to advertise redistributed static routes

			- redistribute option advertises redistributed routes

			- leak-map option allows advertising of routes that would have otherwise been suppressed

	- Authentication

		- Key-Chain

			- Named mode AF-interface:

				- authentication key-chain NAME

			- Interface:

				- ip authentication key-chain eigrp ASN NAME

		- MD5

			- Named mode AF-interface:

				- authentication mode md5

			- Interface:

				- ip authentication mode eigrp ASN md5

		- HMAC SHA2-256

			- Named mode AF-interface. Does not use key chains.

				- authentication mode hmac-sha-256 PASSWORD

	- Filtering

		- Prefix List

			- Remember to end prefix lists with permit 0.0.0.0/0 le 32 as a 'permit any'

			- distribute-list prefix PFX-LIST {in | out} [INT]

			- You can specify the source or destination of the updates with the gateway keyword

			- distribute-list prefix PFX1 gateway PFX2 {in | out}

		- ACL

			- distribute-list ACL {in | out} [INT]

			- Example, filter prefixes with even number in the third octet:

				- access-list 1 permit 0.0.1.0 255.255.254.255  
				  router eigrp ASN  
				    distribute-list 1 in

			- Extended ACL:  source is update-source  
			  destination is network address

				- Example: allow only network 10.10.1.0 from host 20.20.20.1:

				- access-list 100 permit ip host 20.20.20.1 host 10.10.1.0

		- Offset List

			- EIGRP process:

				- offset-list ACL {in | out} NUM [INT]

			- The offset value is added to the delay metric component

		- AD

			- EIGRP cannot advertise routes it does not use itself, so setting their distance to 255 effectively filters them from EIGRP

			- distance 255 IP WC ACL

			- Where IP and Wildcard are the update source(s), and ACL references the routes to filter (matching based on permit)

			- You can perform this filtering per-neighbor  
			  by specifying the IP with a WC of 0.0.0.0:

			- distance 255 NEIGHBOR-IP 0.0.0.0 ACL

		- Route Map

			- EIGRP process:

				- distribute-list route-map NAME {in | out}

			- Example usage, filtering on matched tags

		- Per-Neighbor Prefix Limit

			- Valid for both static unicast and dynamic multicast neighbors

			- Single neighbor:

				- neighbor IP maximum-prefix NUM

			- All neighbors:

				- neighbor maximum-prefix NUM

		- Per-AF Prefix Limit

			- Configured under EIGRP AF or topology base:

			- router eigrp ASN  
			    address-family ipv4 vrf VRF  
			      maximum-prefix NUM

- Advanced

	- Graceful Shutdown

		- Issue shutdown command under EIGRP process, address-family, or AF-interface

	- Bandwidth Pacing

		- Configured under interface or AF-interface, 50% is default:

			- bandwidth-percent NUM

		- Value can be above 100, useful for when the interface bandwidth is set artificially low

		- Interface:

			- ip bandwidth-percent eigrp ASN NUM

	- Neighbor Logging

		- Neighbor adjacency changes are logged by default. Disable under EIGRP process:

			- no eigrp log-neighbor-changes

		- Change the number of lines in the EIGRP event log (default 500):

			- eigrp event-log-size NUM

		- Neighbor warnings are logged at 10 seconds by default:

			- eigrp log-neighbor-warnings SEC

	- Address Families

		- Configure multiple IPv4 and IPv6 sessions

		- router eigrp ASN  
		    address-family ipv4 vrf VRF [autonomous-system ASN]

		- router eigrp NAME  
		    address-family ipv6 [vrf VRF] autonomous-system ASN

	- Summary Leak-Map

		- You can reference a route-map with summarization to advertise select component routes with the summary. 

		- If the referenced route-map does not exist, no component subnets are advertised. If the referenced route-map does exist, but the referenced ACL does not exist, the summary and all component subnets are advertised.

		- Interface:

			- ip summary-address eigrp ASN PFX MASK [AD] leak-map NAME

	- Stub Leak-Map

		- The EIGRP stub leak-map option allows advertising of routes referenced in a route-map that would otherwise have been suppressed.

		- EIGRP process:

			- eigrp stub leak-map ROUTE-MAP

	- Next-Hop Processing

		- next-hop-self is enabled by default on all interfaces and sets the next-hop value of the update to the outbound interface, even when advertising back out the same interface. This behavior can be disabled at the AF interface:

			- no next-hop-self

			- Using no next-hop-self requires disabling  split-horizon on the interface.

		- The no-ecmp-mode option evaluates all paths to a network in the EIGRP table to see if routes advertised from an interface were learned on the same interface. If so, the no next-hop-self command is honored and the received next-hop is used to advertise the route. This is used primarily for DMVPN spoke-to-spoke topologies.

			- no next-hop-self no-ecmp-mode

		- Interface configuration:

			- no ip next-hop-self eigrp ASN [no-ecmp-mode]

	- FRR

		- FRR per-prefix:

			- topology base  
			    fast-reroute per-prefix {all | route-map MAP}

		- Disable FRR load sharing among ECMP LFAs:

			- topology base  
			    fast-reroute load-sharing disable

	- Route-Tag Enhancements

		- You can set a tag for internal routes directly without using a route-map, under the EIGRP process:

			- eigrp default-route-tag NUM

		- Newer versions of IOS support route-tag lists with sequence numbers and permit/deny:

			- Configured globally:

			- route-tag list NAME [SEQ] {permit | deny} TAG WC

	- Per-VRF Autonomous System

		- You can adjust the ASN per-VRF under an existing EIGRP process:

			- router eigrp ASN1  
			    address-family ipv4 vrf VRF  
			      autonomous-system ASN2

	- Named Mode

		- AF-Interface

			- Configure interface-specific properties under the AF-interface:

				- router eigrp NAME  
				    addr ipv4 aut ASN  
				      af-interface INT

			- Use the af-interface default to configure options that can apply to all EIGRP interfaces, such as authentication.

				- router eigrp NAME  
				    addr ipv4 aut ASN  
				      af-interface default

		- Topology Base

			- Commands that effect the entire EIGRP process, which used to be configured directly under the EIGRP process in classic mode

		- Wide Metrics

			- Wide metrics are 64-bit, but the RIB only uses 32-bit metrics. Adjust scale (default 128):

				- router eigrp NAME  
				    addr ipv4 aut ASN  
				      metric rib-scale NUM

			- Also introduced with AF mode is the K6 value:

				- router eigrp NAME  
				    addr ipv4 aut ASN  
				      metric weights TOS K1 K2 K3 K4 K5 K6

		- Add-Path

			- Used on DMVPN hubs to advertise up to four best paths to a destination. This is  used in conjunction with no next-hop-self no-ecmp-mode.

			- Configured on the EIGRP AF-Interface:

				- no next-hop-self no-ecmp-mode  
				  add-paths {1 - 4}

			- Add-path is ECMP only, you cannot use variance

### OSPF

- Basics

	- Router ID

		- Set fixed router ID under OSPF process:

			- router-id RID

		- IOS chooses the highest available loopback IP (if one is present, otherwise the highest IP of any up/up interface). If multiple OSPF processes are configured and the router-id is not manually set, the automatic ID is assigned based on the order the OSPF process was entered into the configuration. For example, if you configure router ospf 2, and then configure router ospf 1, the OSPF PID 2 will get the highest loopback, then OSPF PID 1 will choose the next highest.

	- Internal OSPF Networks

		- network

			- OSPF process:

				- network IP WC area AREA

				- Where IP and WC define the interfaces to participate in the OSPF area.

				- When the IP overlaps multiple network statements, the most specific is used. 

		- interface

			- ip ospf PID area AREA [secondaries none]

		- virtual-link

			- area AREA virtual-link RID <options>

			- AREA is the transit area

			- RID is the router-id of the remote endpoint

			- options include timers and ttl-security

			- If authentication is configured for Area 0, you must configure authentication across the virtual link as well.

			- Keep in mind when configuring a VL that the destination router becomes an ABR, and therefore things like area summarization must then be configured on that router as well.

	- Passive Interface

		- Include subnets but do not form OSPF neighborships. Configured under OSPF process:

			- passive-interface default

			- [no] passive-interface INT

	- Network Type

		- DR

			- broadcast

				- ip ospf network broadcast

			- nonbroadcast

				- Interface:

					- ip ospf network non-broadcast

				- OSPF process:

					- neighbor IP

					- Only requires configuring on one side

			- DR/BDR election manipulation

				- Interface:

					- ip ospf priority NUM

					- Higher = better, 0 = don't participate

					- Higher does not guarantee DR status as there is no preemption. If the current DR has a priority of 1, and a new router is introduced with a priority of 2, the current DR remains until it fails. The only way to guarantee is to set all others to 0.

		- No DR

			- P2P

				- ip ospf network point-to-point

			- P2MP

				- ip ospf network point-to-multipoint

			- P2MP nonbroadcast

				- Interface:

					- ip ospf network point-to-multipoint non-broadcast

				- OSPF process:

					- neighbor IP

					- Only requires configuring on one side

		- Loopback

			- Default network type on loopback interfaces. Advertises as /32 regardless of mask.

			- ip ospf network loopback

		- Unicast vs. Multicast Hellos

			- Hellos are always multicast unless configured with the neighbor IP statement under OSPF

			- neighbor IP 

		- MTU Ignore

			- Disable MTU mismatch detection on the interface:

				- ip ospf mtu-ignore

	- Area Type

		- Stub

			- area AREA stub

			- Must be configured on all routers in the stub area

			- Use with area AREA default-cost to control cost of summary

		- Totally Stubby

			- area AREA stub no-summary

			- Only configured on ABRs, all other routers in the area will be configured as normal stub

		- NSSA

			- area AREA nssa

			- Options:

				- no-redistribution is used when the router is an NSSA ABR and you want to import routes via redistribute to normal areas but not to the NSSA

				- default-information-originate to generate a Type 7 default into the NSSA

				- metric

				- metric-type

				- nssa-only sets the P bit to 0 on the Type 7 LSA so it remains in the NSSA

				- compatible rfc3101

					- Default setting. When comparing two LSAs with equal destination, cost, and non-zero forwarding address, prefer:  
					  -Type-7 with P-bit set  
					  -Type-5  
					  -LSA with higher RID

				- compatible rfc1587

					- Old behavior. Prefer:  
					  -Type-5  
					  -Type-7 with P-bit set and non-zero FA  
					  -Any other Type-7

		- NSTSA

			- area AREA nssa no-summary

			- no-summary prevents Type 3's from being injected into the NSSA

		- Non-Backbone Transit Area

			- By default, non-backbone areas can be used for inter-area transit as long as they have the shortest path. This can be disabled, forcing all inter-area traffic to flow through the backbone:

			- OSPF process:

				- no capability transit

		- NSSA Type 7 to Type 5 Translator

			- area AREA nssa translate type7

			- Options:

				- always makes an ABR translate 7 to 5 unconditionally instead of being elected

				- suppress-fa sets the next-hop of the Type 5 LSAs to 0.0.0.0 (the advertising router)

	- Timers

		- Interface:

			- ip ospf hello-interval SEC

				- When the hello-interval is set, the dead interval is automatically set to 4x the hello-interval

			- ip ospf dead-interval SEC

				- When the dead-interval is set, the hello-interval is NOT automatically adjusted

			- ip ospf retransmit-interval SEC

				- When a router sends an LSA, it keeps it until it receives back an ACK. If no ACK is received, the LSA is retransmitted after 5 seconds by default.

			- ip ospf transmit-delay SEC

				- LSUs have their age incremented by 1 second by default.

	- Metrics

		- Route Types

			- Order of Preference:

				- Intra-Area

				- Inter-Area

				- E1 / N1

					- Metric increases as the route is propagated away from the ASBR

				- E2 / N2

					- Metric remains the same in all areas. Type 2 is the default metric type for redistribution.

		- Cost

			- Auto-cost

				- OSPF process:

					- auto-cost reference-bandwidth MBPS

				- Set the same on all routers for accurate cost calculations

			- Interface Cost

				- ip ospf cost NUM

				- The cost is local and affects incoming routes, but does not affect advertised routes. To affect advertised routes, the cost value must be configured on both ends of the link.

			- Per-Neighbor Cost

				- neighbor IP cost NUM

				- For P2MP you should specify the cost.

		- Administrative Distance

			- OSPF supports adjusting AD for external, inter-area and intra-area routes separately under the OSPF process. 110 is the default.

			- distance ospf external AD

			- distance ospf inter-area AD

			- distance ospf intra-area AD

			- You can also adjust individual routes matched by ACL and update source:

				- distance AD PFX WC ACL

				- Where PFX and WC indicate the source of the advertised route, and the ACL refers to the route itself

	- Authentication

		- Area

			- OSPF process:

				- area AREA authentication [message-digest]

				- This forces an area to be authenticated. You must then configure participating interfaces with authentication options.

		- Interface

			- ip ospf authentication [key-chain NAME | message-digest | null]

			- ip ospf authentication-key PASSWORD

			- Interface-level authentication takes precedence over area-level authentication

		- Clear Text

			- ip ospf authentication  
			  ip ospf authentication-key PASSWORD

		- MD5

			- ip ospf authentication message-digest  
			  ip ospf message-digest-key NUM md5 PASSWORD

		- Null

			- ip ospf authentication null

		- MD5 with multiple keys

			- Configure a new key, OSPF starts sending both new and old keys. After OSPF determines all neighbors know and use the new key, the old key is no longer sent and can be removed.

		- Virtual link authentication

			- area AREA virtual-link RID authentication key-chain KEY

			- Authentication must match Area 0

		- OSPFv2 Cryptographic Authentication

			- Configure a key chain and define the cryptographic algorithm, then apply it to the interface:

			- key chain NAME  
			    key 1  
			      key-string PASSWORD  
			      cryptographic-algorithm hmac-sha-256  
			    
			  ip ospf authentication key-chain NAME

		- OSPFv3 IPsec

			- Configured at the interface.

				- AH:

				- ipv6 ospf authentication ipsec SPI {md5 | sha1} TYPE KEY

				- ESP:

				- ipv6 ospf encryption ipsec spi SPI ALG [TYPE KEY]

			- OSPF process:

				- area AREA authentication ipsec spi SPI ALG [TYPE]

	- Summarization / Default Routes

		- Internal Summarization

			- area AREA range PFX MASK [cost NUM]

			- not-advertise option suppresses the summary and component routes from being advertised outside the area

			- The area range command needs to be configured on all ABRs within the area being summarized

			- More specific routes are suppressed when the summary is created

		- External Summarization

			- Summarization of external route sources under the OSPF process:

				- summary-address PFX MASK

				- not-advertise option filters the summary and components

				- tag option specifies a tag that can be matched during redistribution

				- nssa-only option limits summary to NSSA areas

				- More specific routes are suppressed when the summary is created

		- Discard routes

			- Discard routes are installed automatically when summarization is performed. The default AD for internal is 110, and external is 254. You can change the AD of external and internal discard routes, as well as completely remove them.

			- OSPF process:

				- [no] discard-route [external AD] [internal AD]

		- NSSA and Default Routing

			- Unlike all other stub area types (including NSTSA), a default route is not generated automatically with an NSSA.

			- area AREA nssa default-information-originate

		- Default Routing

			- OSPF process:

				- default-information originate

				- Options:

					- always

					- metric NUM

					- metric-type TYPE

					- route-map NAME

		- Conditional Default Routing

			- OSPF process:

				- default-information originate route-map NAME

				- The route-map matches an ACL that represents a route present in the routing table. If the route is not longer in the routing table, the route-map is not satisfied, and the default is withdrawn.

		- Reliable Conditional Default Routing

			- The same logic and commands as CDR, but instead referencing a tracked object.

			- Configuration example:

			- ip sla 1  
			   icmp-echo 155.1.108.10  
			   frequency 5  
			    
			  ip sla schedule 1 life forever start-time now  
			  track 1 ip sla 1 state  
			    
			  ip route 169.254.0.1 255.255.255.255 Null0 track 1  
			  ip prefix-list PLACEHOLDER seq 5 permit 169.254.0.1/32  
			    
			  route-map TRACK_PLACEHOLDER permit 10  
			   match ip address prefix-list PLACEHOLDER  
			    
			  router ospf 1  
			   default-information originate route-map TRACK_PLACEHOLDER

		- Default Cost

			- area AREA default-cost NUM

			- Configured on ABR or ASBR to set the cost value of the generated default route sent into stub or NSSA

	- Filtering

		- Distribute Lists

			- Intra-area filtering affects only the local routing table, not the OSPF database for the area.

			- OSPF process:

				- distribute-list ACL in

		- AD

			- You can set the AD of routes to 255 to prevent them from being installed in the local routing table.

				- distance 255 PFX WC ACL

				- Where PFX and WC refer to the route source, and ACL refers to the route itself

			- You can ignore all routes by default, and then allow specific routes in with this syntax:

				- distance 255  
				  distance 110 PFX WC ACL

		- Route-Maps

			- Just like distribute-lists, with a route-map intra-area prefixes can be filtered on the local routing table, but the OSPF database is not affected.

			- OSPF process:

				- distribute-list route-map NAME in

			- The advantage is that the route-map can match on more criteria

		- Filtering with Summarization

			- area AREA range PFX MASK not-advertise

			- This suppresses both the summary and component routes from being advertised as Type 3 outside the area

		- LSA Type-3 Filtering

			- area AREA filter-list prefix PFX-LIST {in | out}

		- Forwarding Address Suppression

			- For NSSA ABR, set FA to 0.0.0.0 (self) instead of actual source when translating Type 7 to 5:

			- area AREA nssa translate type7 suppress-fa

		- NSSA ABR External Prefix Filtering

			- With certain NSSA designs, the ABR is  also the ASBR, and redistributed routes are injected as Type 5 into Area 0, and Type 7 into the NSSA. If the NSSA ABR is the only exit point from the area, the Type 7 is unnecessary. 

			- area AREA nssa no-redistribution no-summary

			- With this command, Type 7 LSAs are not injected into the NSSA on the ABR, but it does not prevent other ASBRs in the area from injecting Type 7s into the NSSA.

		- Database Filtering

			- Retain OSPF neighborship across an interface, but filter all LSAs:

				- ip ospf database-filter all out

			- Per-neighbor under OSPF process:

				- neighbor IP database-filter all out

- Advanced

	- Fast Hello

		- Interface:

			- ip ospf dead-interval minimal hello-multiplier NUM

	- SPF Throttling

		- Control SPF calculation MS times:

			- timers throttle spf START HOLD MAX

			- Default Start = 5000, Hold/Max = 10000

	- LSA Throttling

		- Set minimum interval at which OSPF accepts the same LSA from neighbors, default 1000 ms:

			- timers lsa arrival MS

			- MS value should be less than neighbor's hold-interval value on the timers throttle lsa all command

		- Control rate of LSA generation in MS:

			- timers throttle lsa all START HOLD MAX

			- Default Start = 0, HOLD/MAX = 5000

	- LSA Pacing

		- Default 33ms for LSAs in flooding queue interpacket spacing

			- timers pacing flood MS

		- Default 66ms for LSAs in retransmission queue interpacket spacing

			- timers pacing retransmission MS

		- Change interval at which LSAs are grouped together and refreshed, checksummed, or aged. Default 240 seconds:

			- timers pacing lsa-group SEC

	- iSPF

		- Reduce the need to recalculate the entire SPT when changes are not direct.

		- OSPF process:

			- ispf

	- Stub Router

		- Advertise a max metric so that other routers do not prefer reachability through the router.

		- OSPF process:

			- max-metric router-lsa

			- external-lsa NUM option overrides external LSA metric with value

			- include-stub option advertises max metric for stub links in router LSAs

			- on-startup {SEC | wait-for-bgp} option advertises max metric for SEC or until BGP has converged (up to 10 minutes)

			- summary-lsa NUM option overrides summary LSA metric with value

	- Graceful Shutdown

		- Interface:

			- ip ospf shutdown

		- OSPF process:

			- shutdown

		- Related to stub router feature:

			- max-metric router-lsa

	- Generic TTL Security Mechanism

		- Interface:

			- [no] ip ospf ttl-security [hops NUM]

		- OSPF process:

			- ttl-security all-interfaces [hops NUM]

	- FRR (single-hop)

		- Enable per-prefix LFA FRR under the OSPF process:

			- fast-reroute per-prefix enable [area AREA] prefix-priority {high | low}

		- FRR repair path tie-breaking rules:

			- fast-reroute tie-break  
			    options

		- Interface:

			- ip ospf fast-reroute per-prefix {candidate | protection} [disable]

			- Candidate = interface can be used as the next-hop in a repair path

			- Protection = Interface is protected, routes pointing to the interface can have a repair path

			- Disabled = forces role, example candidate disable means the interface is protected

	- LFA (multi-hop)

		- Enable per-prefix remote LFA FRR under the OSPF process. This uses LDP for tunneling.

			- fast-reroute per-prefix remote-lfa [area AREA] tunnel mpls-ldp

		- Restrict distance to tunnel endpoint per-prefix:

			- fast-reroute per-prefix remote-lfa [area AREA] maximum-cost NUM

		- All devices in the network that can be selected as tunnel termination points must accept targeted LDP sessions:

			- mpls ldp discovery targeted-hello accept

	- Demand Circuit

		- Suppress periodic hellos and LSA refreshes:

			- ip ospf demand-circuit

		- Ignore demand circuit operation:

			- ip ospf demand-circuit ignore

	- Transit Prefix Filtering

		- area AREA no-transit

	- Resource Limiting

		- Limit the number of non-self-generated LSAs in the OSPF process LSDB:

			- max-lsa NUM <options>

		- Limit the number of routes that can be redistributed:

			- redistribute maximum-prefix NUM

	- Flooding Reduction

		- Suppress unnecessary flooding of LSAs in stable topologies. Configured at the interface:

			- ip ospf flood-reduction [disable]

	- Prefix Suppression

		- Suppression of all IP prefixes except loopbacks, secondaries, and passive interfaces.

		- OSPF process:

			- prefix-suppression

		- Interface (overrides process level):

			- [no] ip ospf prefix-suppression

			- Interface configuration also suppresses loopbacks and passive interfaces. Only secondaries are advertised.

	- OSPFv3 Multi-AF Mode

		- Still requires IPv6 enabled

		- router ospfv3 PID  
		    address-family ipv6 unicast  
		    address-family ipv4 unicast

## BGP

### Neighbor Relationships

- Timers

	- BGP process

		- BGP process:

			- timers bgp KEEPALIVE HOLD [MIN]

			- Default KEEPALIVE is 60s, HOLD is 180s

			- MIN refers to the minimum acceptable time negotiated with the peer

	- Per-Neighbor

		- neighbor IP timers KEEPALIVE HOLD [MIN-HOLD]

		- Where MIN-HOLD is the minimum number of seconds acceptable from the neighbor when the value is negotiated between neighbors. KEEPALIVE is 60s by default, and HOLD is 180s by default.

		- Advertisement interval (Default 30s for global eBGP, immediate for all others):

			- neighbor IP advertisement-interval SEC

- eBGP

	- Basic

		- A basic eBGP connection is one where the peer is in a different ASN as the local router:

		- router bgp ASN1   neighbor IP remote-as ASN2

		- By default, eBGP sets the next-hop value to itself when advertising to an eBGP peer.

	- ebgp multihop

		- neighbor IP ebgp-multihop [TTL]

		- This command is used when the peers are not directly connected. This command does not work if the only route to the multihop peer is through the default route 0.0.0.0:

	- next-hop-unchanged

		- This option is typically used in conjunction with ebgp-multihop. When an update is sent to an eBGP peer, the NEXT_HOP is normally changed to that of the outgoing interface. This option preserves the existing NEXT_HOP information, such as that received from an iBGP route:

		- neighbor IP next-hop-unchanged [allpaths]

		- The allpaths option propagates the next hop unchanged for all paths (both iBGP and eBGP) to the neighbor.

	- disable-connected-check

		- Used when the peer is not using the directly-connected interface (such as a loopback), and  neighbor IP ebgp-multihop command is set to a value of 1. Otherwise, this command is unnecessary.

		- neighbor IP disable-connected-check

		- Use in conjunction with update-source when necessary:

		- neighbor IP update-source INT

		- The difference between disable-connected-check and ebgp-multihop is that when a router receives a packet destined for itself, it does not decrement the TTL, which is why this command is used between two directly-connected routers that are using different interfaces.

	- Remove Private AS

		- Remove private ASNs from the AS_PATH of outbound eBGP updates:

		- neighbor IP remove-private-as [all [replace-as] ]

		- Where the all removes all private ASNs in the path

		- The all replace-as combination causes all private ASNs to be replaced with the router's local ASN. Use this option when the AS path length must remain the same for path selection purposes.

	- Local-AS

		- Enable a remote peer to connect using a different ASN than what the local router is configured for:

		- router bgp ASN1   neighbor IP remote-as ASN2   neighbor IP local-as ASN3

		- Remote neighbor is configured to connect to ASN3, and will see ASN3 ASN1 prepended in the updates.

		- Using the no-prepend keyword causes updates received from the eBGP peer to not have the value specified with local-as prepended. Using the above example, if no-prepend is added to the local-as statement, ASN3 will not be present in incoming updates, but outbound updates still have ASN3 present:

		- neighbor IP local-as ASN3 no-prepend

	- Local-AS Replace-AS/Dual-AS

		- The no-prepend replace-as combination hides the real AS in outbound updates.

		- router bgp ASN1   neighbor IP remote-as ASN2   neighbor IP local-as ASN3 no-prepend replace-as

		- In the previous example, outgoing updates will be prepended with only ASN3, not ASN3 ASN1.

		- The no-prepend replace-as dual-as combination can be used during ASN migration to allow the remote to peer with either ASN, and the hiding peer will use the negotiated ASN to prepend updates sent to the external peer:

		- router bgp ASN1   neighbor IP remote-as ASN2   neighbor IP local-as ASN3 no-prepend replace-as dual-as

		- In the above example, ASN2 could connect to either ASN1 or ASN3, and the outbound updates will not prepend the other ASN.

	- Allow-AS

		- Accept prefixes with the local AS in the AS_PATH:

		- neighbor IP allowas-in [NUM]

		- Where NUM is an optional value of the number of local AS number occurrences. The default is 3

		- Commonly used with MPLS L3VPN for sites using the same BGP ASN.

	- AS Override

		- Compare remote ASN with ASN stored in the end of the of the AS_PATH. If the ASNs match, the ASN in the AS_PATH is replaced with the local router's ASN.

		- neighbor IP as-override

		- Typically used on the PE side of MPLS L3VPN

- iBGP

	- Basic

		- A basic iBGP connection is one where the peer is in the same ASN as the local router:

		- router bgp ASN1   neighbor IP remote-as ASN1

		- By default, iBGP does not change the next-hop when advertising to an iBGP peer.

	- Route Reflector

		- Basic

			- A router becomes a RR as soon as a single client is configured:

			- neighbor IP route-reflector-client

		- Cluster

			- Set the cluster ID:

			- bgp cluster-id ID

			- You can also set the cluster ID per-neighbor, which is useful for loop prevention if the RR receives its cluster ID or any of the per-neighbor cluster IDs within the CLUSTER_LIST of a route. This is also useful for disabling client-to-client reflection per-neighbor for when clients are fully-meshed:

			- neighbor IP cluster-id ID

		- Controlling Route Reflection:

			- Client-to-Client reflection is the default. You can disable this behavior if the clients are peered with each other in a full mesh:

			- no bgp client-to-client reflection

			- Or disable the behavior within specific RR clusters:

			- no bgp client-to-client reflection intra-cluster cluster-id {ID | any}

		- Neighbor Allow Policy

			- Typically used when merging/migrating ASes, the neighbor allow-policy command enables a RR to change iBGP attributes, which it normally does not do.

			- Example, a RR in AS 4000 treating a neighbor in AS 2500 as if it were iBGP. The iBGP attributes (LOCAL_PREF, ORIGINATOR_ID, CLUSTER_ID, CLUSTER_LIST) will not be dropped from routes in advertisements to and from the neighbor. The AS 2500 is prepended to the AS_PATH in all routes to and from the neighbor. The neighbor allow-policy command also enables the RR to be configured with a route-map that changes iBGP policies.

			- router bgp 4000   neighbor IP remote-as 2500   neighbor IP local-as 2500   neighbor IP route-reflector-client   neighbor IP allow-policy

			- The combination of remote-as and local-as being the same allows the router to treat the peer as iBGP

	- Confederation

		- Configure the BGP process with the router's participating Sub-AS:

			- router bgp SUB-AS

		- Identify the AS to peers outside the confederation:

			- bgp confederation identifier ASN

		- Identify the other participating Sub-ASes:

			- bgp confederation peers SUB-AS1 SUB-AS2...

		- Confederation eBGP peers behave like iBGP for next-hop processing and may require next-hop-self

		- Confederations also preserve other iBGP attributes across confederation eBGP peers such as MED and local preference. A route received from a confederation eBGP peer has a default AD of 200.

- Update-Source

	- Control the interface used as the TCP source for BGP sessions per-neighbor:

	- neighbor IP update-source INT

- Synchronization

	- Synchronization is disabled by default. When enabled, BGP does not consider iBGP routes valid when there is not a matching IGP route in the routing table. Enable under the BGP process:

	- synchronization

	- If the underlying IGP is OSPF, the OSPF and BGP RID must be the same, otherwise BGP will not advertise the prefix.

- TTL Security

	- For eBGP peers. This feature is mutually-exclusive from ebgp-multihop:

	- neighbor IP ttl-security hops HOPS

- Authentication

	- Simple MD5 authentication:

	- neighbor IP password PASSWORD

	- You can enter a new password on an existing session and it will not be immediately torn down. You have until the expiration of the hold time to set the password on both ends of the connection.

- Peer Groups / Templates

	- Peer Group

		- Configure common options under a peer-group:

			- neighbor GROUP peer-group neighbor GROUP <options>

		- Assign a neighbor to a peer-group:

			- neighbor IP peer-group GROUP

	- Peer Policy Template

		- Peer Policy Template configuration mode:

			- template peer-policy NAME

			- Options apply to specific address families, such as filtering, AS_PATH and next-hop processing

		- Inherit peer policy template configuration from another peer policy template:

			- template peer-policy NAME   inherit peer-policy POLICY SEQ

		- Send a peer policy template to a neighbor so that the neighbor can inherit the configuration:

			- neighbor IP inherit peer-policy POLICY

	- Peer Session Template

		- Peer Session Template configuration mode:

			- template peer-session NAME

			- Options apply to groups of neighbors that share the same common session elements, such as passwords, timers, update-source, multihop, etc.

		- Inherit peer session template configuration from another peer session template:

			- template peer-session NAME1   inherit peer-session NAME2

		- Send a peer session template to a neighbor so that the neighbor can inherit the configuration:

			- neighbor IP inherit peer-session NAME

- Dynamic Neighbors

	- BGP process:

	- router bgp ASN   neighbor NAME peer-group   neighbor NAME remote-as ASN2 [alternate-as ASN3 ... ASN7]   bgp listen range PFX/LEN peer-group NAME

	- This works only with eBGP peers, not iBGP. Up to five additional ASNs can be configured as acceptable.

	- bgp listen limit NUM option sets the number of dynamic neighbors allowed, default 100

	- eBGP neighbor uses regular configuration.

- Active vs. Passive Peers

	- Configure the neighbor as passive so that this router does not initiate the TCP connection:

	- neighbor IP transport connection-mode passive

- Path MTU Discovery

	- Enabled by default. Disable under BGP process:

		- no bgp transport path-mtu-discovery

	- Per neighbor:

		- neighbor IP transport path-mtu-discovery [disable]

- Multi-Session TCP Transport Per-AF

	- Enable a separate TCP transport session between a neighbor for each address family:

	- neighbor IP transport multi-session

- Fast Fallover

	- Internal

		- Per-neighbor, identical to external configuration:

		- neighbor IP fall-over [bfd | route-map MAP]

		- The route-map allows session deactivation based on when a route to the BGP peer changes. The route-map is evaluated against the new route, and if a deny statement is returned, the peer session is reset. The route-map is not used for session establishment. Only match ip address and match source-protocol can be used in the route map, no other match or set commands are supported.

	- External

		- Enabled by default under the BGP process, the BGP session between directly-connected peers is immediately reset if the link goes down. When disabled, BGP waits for the holdtime to expire.

		- BGP process:

			- [no] bgp fast-external-fallover

		- Per-Interface:

			- ip bgp fast-external-fallover {permit | deny}

		- Per-neighbor:

			- neighbor IP fall-over [bfd | route-map MAP]

		- The route-map allows session deactivation based on when a route to the BGP peer changes. The route-map is evaluated against the new route, and if a deny statement is returned, the peer session is reset. The route-map is not used for session establishment. Only match ip address and match source-protocol can be used in the route map, no other match or set commands are supported.

		- Example: reset the peering session if a route with a prefix of /28 or more specific to the peer is no longer available:

		- router bgp ASN1   neighbor IP remote-as ASN2   neighbor IP fall-over route-map CHECK-NBR  ip prefix-list FILTER28 seq 5 permit 0.0.0.0/0 ge 28 route-map CHECK-NBR permit 10   match ip address prefix-list FILTER28

- Prefix Independent Convergence (PIC)

	- Backup path must be a unique next-hop that is not the same as the next-hop of the best path

	- VPNv4 AF configuration protects all VRFs, IPv4 VRF configuration protects individual VRFs, BGP process configuration protects the global routing table.

	- bgp additional-paths install

- Update Delay

	- By default BGP waits 120s for neighbors to be established before sending initial updates.

	- bgp update-delay SEC

- Description

	- Assign a description per-neighbor:

	- neighbor IP description TEXT

- Graceful Shutdown

	- Disable a neighbor but keep configuration:

	- neighbor IP shutdown [graceful SEC]

	- Where the graceful option sends the GSHUT community along with the number of seconds before the shutdown will occur.

### Next-Hop Processing

- next-hop-self

	- Set the NEXT_HOP attribute in outgoing updates to this router's IP address:

		- neighbor IP next-hop-self [all]

		- Without the all keyword, only the NEXT_HOP of eBGP-learned routes are updated by the RR. With the keyword, both eBGP- and iBGP-learned routes are updated by the RR

	- You can also set the value in a route-map:

		- set ip next-hop-self

- Manual next-hop modification (aka third-party next hop)

	- Set inside a route-map:

	- set ip next-hop IP

	- You can also set the next-hop by peer address:

	- set ip next-hop peer-address

	- When the route-map is applied inbound, the next-hop for matching routes becomes that of the BGP peer

	- When the route-map is applied outbound, the next-hop for matching routes becomes the peering address of the local router

- Next-Hop Tracking

	- Monitors changes in BGP NEXT_HOP attribute within routes. Enabled by default as:

	- bgp nexthop enable

	- Disable with no

- Conditional Next-Hop Tracking

	- A route-map can be referenced and is used during bestpath calculation and applied to the route that covers the NEXT_HOP attribute. If the route-map is not satisfied, the next-hop route is marked unreachable.

	- Example: route-map that permits a route to be considered as a next-hop route only if the address mask length is more than 25 (useful to avoid aggregates as next-hops)

	- router bgp ASN   bgp nexthop route-map MAP  ip prefix-list FILTER permit 0.0.0.0/0 ge 25  route-map MAP   match ip address prefix-list FILTER

- Next-Hop Trigger Delay

	- Default delay is 5s, but can be changed:

	- bgp nexthop trigger delay SEC

- BGP scanner

	- Next-hop validation occurs every 60 seconds by default. Change under the BGP process:

	- bgp scan-time SEC

	- Can be configured per-AF

### NLRI origination

- Conditional Advertisement

	- neighbor IP advertise-map MAP1 {exist-map MAP2 | non-exist-map MAP2}

	- Advertise to the neighbor the routes present in the advertise-map if either the exist-map or non-exist-map is satisfied. The exist-map is satisfied when the route exists in both the advertise-map and the exist-map. The non-exist-map is satisfied when the route is present in the advertise-map, but not in the non-exist-map. If either exist-map or non-exist-map is not satisfied, the routes in advertise-map are not advertised to the neighbor.

- network

	- Specify network to be advertised by BGP:

	- network PFX [mask MASK] [route-map MAP]

	- Use mask MASK to advertise non-classful networks

	- Use route-map MAP to filter the networks to be advertised, add communities, etc.

- Conditional Route Injection

	- CRI allows you to originate a more specific prefix into BGP (deaggregation, similar to an unsuppress-map) without a corresponding match (meaning it can be performed on any router, not just the one originating the aggregate). The components of CRI are the inject-map, and the exist-map. The exist-map references separate prefix lists that identify the aggregate prefix and its source. 

	- Example configuration:

	- ip prefix-list ROUTE permit 10.1.1.0/24 ip prefix-list ROUTE_SOURCE permit 10.2.1.1/32 ip prefix-list ORIGINATED_ROUTES permit 10.1.1.0/25 ip prefix-list ORIGINATED_ROUTES permit 10.1.1.128/25  route-map LEARNED_PATH   match ip address prefix-list ROUTE   match ip route-source prefix-list ROUTE_SOURCE  route-map ORIGINATE   set ip address prefix-list ORIGINATED_ROUTES  router bgp ASN   bgp inject-map ORIGINATE exist-map LEARNED_PATH [copy-attributes]

	- The copy-attributes option configures the injected routes to inherit the attributes of the aggregate route. If this option is not used, the injected prefixes use the default attributes for locally-originated routes.

- Default

	- Configured under BGP process, must be used in conjunction with redistribution:

	- default-information originate

	- Per-neighbor (do not use with the above method):

	- neighbor IP default-originate [route-map MAP]

	- With per-neighbor configuration, the router does not require 0.0.0.0 in the local routing table. Without the route-map, the default is advertised to the neighbor unconditionally. The route-map makes the default advertisement conditional.

	- Example: advertise default to neighbor if 10.10.0.0/16 is present in the routing table:

	- router bgp ASN   neighbor IP default-originate route-map MAP  route-map MAP   match ip address 100  access-list 100 permit ip host 10.10.0.0 host 255.255.0.0

### Filtering

- Prefix / Length

	- Inbound updates:

		- distribute-list prefix PFXLIST in [INT]

	- Outbound updates:

		- distribute-list prefix PFXLIST out [INT]

	- Can be configured per-neighbor:

		- neighbor IP prefix-list NAME {in | out}

- ACL

	- Inbound updates:

		- distribute-list ACL in [INT]

	- Outbound updates:

		- distribute-list ACL out [INT]

	- Per-neighbor:

		- neighbor IP distribute-list ACL {in | out}

	- Extended ACL logic, the "source" defines the prefix, the "destination" defines the prefix mask:

	- 10.0.0.0/16 only: permit ip 10.0.0.0 0.0.0.0 255.255.0.0 0.0.0.0  Any number in 3rd octet with /24: permit ip 10.0.0.0 0.0.255.0 255.255.255.0 0.0.0.0 Alternate since matching exactly /24: permit ip 10.0.0.0 0.0.255.0 host 255.255.255.0  Any in 2nd, 3rd, 4th network with /25 - /32 mask: permit ip 10.0.0.0 0.255.255.255 255.255.255.128 0.0.0.127

- Maximum Prefix

	- Control the number of prefixes allowed to be received from a peer, and optionally control what happens when the max number is reached. Without any options, the peering session is disabled when the max is reached:

	- neighbor IP maximum-prefix NUM [threshold] [restart MIN] [warning-only]

	- threshold option specifies the percentage when the router starts to generate warning messages. Value is 1 - 100, default 75

	- restart option specifies the number of minutes after which the peering session will be reestablished after having been disabled due to reaching the max

	- warning-only option allows the router to generate syslog messages when the max is reached, instead of terminating the peering session

- AS_PATH

	- Identify via regex globally:

		- ip as-path access-list NUM {permit | deny} REGEX

	- Apply filter per-neighbor in BGP:

		- neighbor IP filter-list NUM {in | out}

	- You can also match with a route-map:

		- route-map NAME   match as-path NUM

- Community

	- Standard

		- Identify standard 32-bit communities via community-list:

		- ip community-list standard NAME {deny | permit} CRITERIA

		- CRITERIA includes:

			- community value

			- internet

			- local-as

			- no-advertise

			- no-export

			- gshut (graceful shutdown community)

		- ip community-list expanded NAME {deny | permit} REGEX

		- Expanded community lists allow matching via regex

	- Extended

		- Used to filter routes for VRFs and MPLS VPNs

		- Extended communities are 64-bit for IPv4, and 160-bit for IPv6

		- ip extcommunity-list {NUM | NAME} OPTIONS

		- If you press enter after the NUM or NAME, you enter subconfiguration mode to enter the options.

			- [SEQ} {permit | deny}

			- REGEX

			- rt NUM   (route-target value)

			- soo NUM  (site of origin value)

			- community value

	- Processing: when a permit value is matched, all other community values default to implicit deny. Unlike an ACL, you can have a list with only deny statements. Multiple communities in the same list are a logical AND, multiple communities in separate lists are a logical OR

	- Match inside route-map:

		- route-map NAME   match community LIST

		- route-map NAME   match extcommunity LIST

- Outbound Route Filtering

	- Advertise ORF capabilities to a peer:

	- neighbor IP capability orf prefix-list [send | receive | both]

	- The sending router defines a prefix-list and configures the neighbor with neighbor IP prefix-list PFX in

	- The receiving router installs the prefix list, and filters toward the neighbor according to the prefix list

- Enforce First AS

	- Filter updates received from eBGP peers that do not list their ASN at the beginning of the AS_PATH in the incoming update. BGP process:

	- bgp enforce-first-as

- Suppress Inactive

	- BGP does not suppress routes by default, but you can configure it to not advertise routes that are not installed in the RIB (such as those with rib-failure):

	- bgp suppress-inactive

- Administrative Distance

	- BGP process:

		- distance bgp EXT INT LOCAL

- Table Map / Selective Route Download

	- Reference a route-map that modifies a metric, tag, or traffic index value of routes that pass the route-map when the local IP routing table is updated with BGP-learned routes. Configured under the BGP process:

	- table-map RM_NAME [filter]

	- Selective Route Download uses the filter keyword. Without the keyword, all routes are added to the BGP RIB, whether or not they are permitted by the referenced route-map. With the filter keyword, routes denied by the route-map are not added to the BGP RIB.

	- Example:

	- ip community-list 1 permit 10:10 route-map RM_BGP permit 10  match community 1  set ip precedence flash router bgp ASN  table-map RM_BGP

### Aggregation

- aggregate-address PFX MASK

	- as-set option generates AS_SET path information. The ATOMIC_AGGREGATE attribute is automatically set unless this option is used. Creation of the aggregate route removes the AS_PATH information unless as-set is issued.

	- as-confed-set option generates AS_CONFED_SET path information

	- summary-only option removes all more-specific routes from updates

	- suppress-map references a route-map of individual more-specific routes to be suppressed

	- unsuppress-map references a route-map of individual more-specific routes to be advertised with the aggregate. This can also be configured per-neighbor:  neighbor IP unsuppress-map MAP

	- attribute-map is used to specify the attributes of the aggregate route. Without specifying the attributes, they are inherited additively from the component subnets (which may include the no-export community). Can also be used in conjunction with as-set

	- advertise-map is used with the as-set option to specify the component subnets that will be used to make up the attributes of the aggregate. This allows you to control which ASNs end up in the AS_SET, as well as remove prefixes with unwanted BGP attributes (like specific communities)

- auto-summary

	- Routes injected into BGP via redistribution are summarized on a classful boundary. This does not affect routes injected via the network command.

### Path Selection

- Cost Extended Community

	- Enable BGP to consider IGP metrics carried in routes inside an AS as the first point of bestpath selection. Also known as pre-bestpath POI point of insertion.

	- By default, BGP evaluates the COST extended community, if present, before anything else. Disable globally with:

		- bgp bestpath cost-community ignore

	- Apply the cost community attribute to internal routes via route-map:

		- set extcommunity cost ID COST

		- Where ID is from 0 - 255 and COST is 0 - 4B

- Weight

	- Weight can be assigned per-neighbor:

		- neighbor IP weight NUM

	- You can also set the weight of routes in a route-map:

		- set weight NUM

- Local_Pref

	- The default value is 100. Change under the BGP process:

		- bgp default local-preference NUM

	- You can match and set the local preference in a route-map:

		- match local-preference NUM

		- set local-preference NUM

- AS_PATH

	- AS Prepending

		- Prepend the AS from inside a route-map:

		- set as-path prepend <ASes>

		- Where <ASes> is any number of ASNs separated by a space. Outside of the lab environment, you should only prepend your own ASNs.

		- Apply the route-map on the BGP neighbor statement.

	- AS_Path Ignore

		- Do not consider the AS_PATH in the path selection process:

		- bgp bestpath as-path ignore

- Origin

	- Manually set origin code in route-map:

		- set origin {igp | incomplete}

- MED

	- Compare MED for paths from neighbors in different ASes (otherwise MED is only compared between neighbors in the same AS):

		- bgp always-compare-med

	- When comparing multiple paths to the same prefix to the same AS, IOS compares the newest route to the next-newest. Deterministic MED causes all candidates to be compared, so that the result is the same each time:

		- bgp deterministic-med

	- Assign a value of infinity to routes missing the MED attribute (making a path without MED the least desirable):

		- bgp bestpath med missing-as-worst

	- Compare MED between paths learned from confederation peers:

		- bgp bestpath med confed [missing-as-worst]

	- You can set the MED value in a route-map:

		- set metric VALUE

	- Set the MED value to the IGP metric associated with the next-hop of the route when advertising to eBGP neighbors:

		- set metric-type internal

- Router ID

	- When enabled, BGP chooses the path through the neighbor with the lowest router ID. The default is to choose the route first received (oldest route).

	- Set local router-id under BGP process:

	- bgp bestpath compare-routerid

	- bgp router-id IP

	- Router ID can be set per-VRF

- DMZ Link Bandwidth

	- Used to distribute traffic over external links with unequal bandwidth when multipath load balancing is enabled

	- BGP process:

		- bgp maximum-paths NUM bgp dmzlink-bw neighbor IP dmzlink-bw

	- This information can be carried throughout the AS in extended communities, so that iBGP peers can take advantage of the unequal bandwidth load balancing across the eBGP links:

		- neighbor IP send-community extended bgp maximum-path ibgp bgp dmzlink-bw neighbor IP dmzlink-bw

- Max-AS

	- Configure the BGP process to discard routes that have a number of ASNs in the AS_PATH beyond the set limit:

		- bgp maxas-limit NUM

	- No routes are discarded by default

- Multipath

	- maximum-paths NUM

	- maximum-paths ibgp NUM

	- MPLS L3VPN:

		- maximum-paths eibgp NUM

- Add Path

	- This is a negotiated capability.

	- bgp additional-paths {[send] [receive] [disable]}

	- BGP process or per-neighbor:

		- neighbor additional-paths {[send] [receive] | [disable]}

	- bgp additional-paths select 

		- all includes all paths with unique next-hops are eligible for selection

		- backup uses the second best path as a backup path

		- best {2 | 3}

		- best-external uses the second best path from among those received from external neighbors. Configured on PE or RR

		- group-best chooses the best path from each AS when there are multiple ASes

	- neighbor advertise additional-paths [best NUM] [group-best] [all]

	- Disable per-neighbor when enabled under the process:

		- neighbor additional-paths disable

	- You can also adjust attributes of the additional paths individually with a route-map and the match additional-paths advertise set command:

		- route-map ADD_PATH   match additional-paths advertise-set best 2   set metric 1000 route-map ADD_PATH permit 20  router bgp ASN   neighbor IP route-map ADD_PATH out   neighbor IP advertise additional-paths best 2

- BGP Backdoor

	- A network that is marked as a backdoor is not sourced by the local router, but should be learned from external neighbors. Backdoor networks use an AD of 200, making default IGPs more preferable. 

	- Configured under the BGP process:

		- network PFX mask MASK backdoor

	- This configuration may be necessary when learning the same routes via eBGP that you learn via an IGP. The IGP routes must be preferred or else you will have recursive errors.

### Dampening

- When enabled, when a prefix is withdrawn, it is considered a flap the its penalty is increased by 1000. An attribute change increases the penalty by 500.

- bgp dampening [HL RU SP MAX]

	- HL = half-life, time in minutes after which a penalty is decreased (15m default)

	- RU = reuse, based on accumulated penalties (default 750). When the penalty falls below this value, the route can be used again

	- SP = suppress, route is suppressed when its penalty exceeds the limit (default 2000)

	- MAX = max suppress time (default 4x half-life, 60m)

- Dampening with Route-Map:

	- bgp dampening route-map NAME

	- Where the attributes are configured per-prefix with set dampening

### 4-Byte ASN

- Default BGP display is asplain (decimal). Change to asdot notation:

	- bgp asnotation dot

- Configure the BGP ASN as either asplain or asdot:

	- router bgp 100000

	- router bgp 10.1234

### BGP Soft Reconfiguration

- Route Refresh:

	- neighbor IP soft-reconfiguration inbound

- Perform inbound soft reconfiguration for peers that do not support route-refresh capability:

	- bgp soft-reconfig-backup

### Communities

- Standard

	- Communities are not sent to any neighbor by default:

		- neighbor IP send-community [both | standard]

	- Assign a community to a route inside a route-map:

		- set community NUM [additive]

		- Where additive adds the new community to the existing list of communities associated with the route, otherwise all communities are replaced.

- Extended

	- Communities are not sent to any neighbor by default:

		- neighbor IP send-community [both | extended]

- No-Advertise

	- Do not advertise this route to any peer, internal or external:

		- set community no-advertise

- No-Export

	- Keep route inside the AS and do not advertise to eBGP peers:

		- set community no-export

- Local-AS

	- Keep this route inside the local confederation AS

		- set community local-as

- Internet

	- Advertise the route to anyone

		- set community internet

- Deletion

	- Remove specific communities from updates using a route-map referencing a standard or extended community list:

		- ip community-list LIST permit COMM  route-map DELCOMM   set {comm-list | extcomm-list} COMM delete  router bgp ASN   neighbor IP route-map {in | out}

		- COMM in the community-list is the community to be selected for deletion. You can also use regex, such as 100:.* which indicates all communities beginning with 100: 

	- Remove all communities inside a route-map:

		- set community none

- Display

	- By default, communities are displayed in 32-bit format. They can be displayed in the AA:NN format under the BGP process:

		- ip bgp-community new-format

### Multi-Homing

- Filter to prevent transit, based on as-path or ACL/prefix-list. Example using as-path, prevent local AS 789 from becoming transit between AS 123 & AS 456:

- ip as-path access-list 1 permit ^123 ip as-path access-list 2 permit ^456  route-map RM_123_OUT deny 10  match as-path 2 route-map RM_123_OUT permit 20  route-map RM_456_OUT deny 10  match as-path 1 route-map RM_456_OUT permit 20  router bgp 789  neighbor 1.2.3.1 remote-as 123  neighbor 1.2.3.1 route-map RM_123_OUT out  neighbor 4.5.6.1 remote-as 456  neighbor 4.5.6.1 route-map RM_456_OUT out

### MP-BGP

- IPv4 Default

	- BGP process:

	- IPv4 unicast is the default when you enter the neighbor remote-as command, unless you enter the following command:

	- no bgp default ipv4-unicast

	- After entering this command, you can configure regular IPv4-based BGP commands under the address family:

	- address-family ipv4 unicast

- IPv6

	- BGP process:

		- address-family ipv6 unicast

- Dual Stack (Dual Session)

	- BGP process:

		- neighbor IP remote-as ASN neighbor IPv6 remote-as ASN address-family ipv4   neighbor IP activate   no neighbor IPv6 activate address-family ipv6   neighbor IPv6 activate

- VRF

	- BGP process:

		- address-family {ipv4 | ipv6} unicast vrf VRF

- VPN

	- BGP process:

		- address-family {vpnv4 | vpnv6} {unicast | multicast}

- Multicast

	- Concept is similar to static mroutes in that you can alter the RPF so that it does not strictly follow the unicast path. Additionally, with BGP you can apply policies.

	- PIM must be enabled on interfaces connecting the two ASes together. However, the RPs must remain separate. PIM BSR border can be used for this.

	- BGP process:

		- address-family {ipv4 | ipv6} multicast  neighbor IP activate

	- Border Interface:

		- ip pim sparse-mode ip pim bsr-border

	- Inter-Domain multicast uses MSDP:

		- ip msdp peer IP connect-source INT remote-as ASN

- For all address families except the default IPv4 unicast (unless no bgp default ipv4-activate is configured), you must activate each neighbor under the respective SAFI configuration.

	- neighbor {IP | peer-group NAME} activate

### BGP over GRE

- Similar in concept to an MPLS BGP-free core, use GRE to peer BGP across tunnel endpoints, then the underlying "core" network does not have to participate in BGP, preventing prefix blackholing

## MPLS L3VPN

### LDP

- LDP Router ID

	- Automatically set the same way as other RIDs

	- Set manually globally:

		- mpls ldp router-id IP [force]

		- The force keyword causes LDP sessions to be re-established if it causes the current LDP RID to change

	- IMPORTANT: unlike other RIDs, the number chosen must be an IP that is reachable by other LDP neighbors, because it is used for the UDP/TCP session endpoints.

- Connection

	- Directly-Connected

		- Interface:

			- mpls ip

		- LDP Autoconfiguration

			- LDP autoconfiguration enables LDP on every interface associated with IS-IS or OSPF:

				- router ospf PID   mpls ldp autoconfig [area AREA]

			- Disable per-interface:

				- no mpls ldp igp autoconfig

		- LDP IGP Synchronization

			- LDP IGP sync causes the link cost of a newly-established adjacency to be set to the maximum until LDP informs OSPF or IS-IS that it is okay to use the link. This is useful because when a link comes online, IGP is quicker to converge than LDP, and this minimizes dropped MPLS traffic. Configured under router process:

				- router ospf PID   mpls ldp sync

			- Per-interface:

				- [no] mpls ldp igp sync

			- Reference: http://blog.ipspace.net/2011/11/ldp-igp-synchronization-in-mpls.html

			- Global Holddown Control enables a maximum wait time before using LDP:

				- mpls ldp igp sync holddown MS

	- Targeted Session

		- interface tunnel NUM   tunnel destination IP   mpls ip

		- mpls ldp neighbor [vrf VRF] RID targeted

		- Default LSR behavior is to ignore targeted requests. At least one endpoint must be configured with the following:

			- mpls ldp discovery targeted-hello accept [ACL]

		- Can also be used between two directly connected neighbors, such as peering between loopbacks over multiple connected links

		- LDP session protection enables an adjacency to remain up either indefinitely (default) or for a specified number of seconds. This is useful if a directly-connected link goes down, but the LDP RID is still available through other paths. Configured globally:

			- mpls ldp session protection [ACL] [duration SEC]

	- Transport Address

		- You can specify the address to be used for LDP transport under the interface:

			- mpls ldp discovery transport-address {interface | IP}

	- Authentication

		- MD5 used, configured per-neighbor globally:

			- mpls ldp neighbor RID password PASS

		- Require LDP authentication:

			- mpls ldp password required

	- Timers

		- Configured globally:

			- mpls ldp discovery hello interval SEC

			- mpls ldp discovery hello holdtime SEC

		- LDP Session Holdtime (lower of neighbor values is used):

			- mpls ldp holdtime SEC

	- MTU

		- Interface:

			- mpls mtu MTU

- Label Control

	- Explicit Null

		- Prevents PHP, useful for preserving QoS markings.

		- Global:

			- mpls ldp explicit-null [ACL]

	- Default Route

		- A label is not created for the default route unless manually configured globally:

			- mpls ip mpls ip default-route

	- Static Assignment

		- Label Assignment and Reservation

			- Choose the range for which labels are dynamically assigned:

				- mpls label range MIN MAX

			- Reserve the label range so they are not dynamically assigned:

				- mpls label range MIN MAX static MIN MAX

			- Example, use labels in the range of 200-100000 but reserve 16-199 as statically assigned:

				- mpls label range 200 100000 static 16 199

		- Static label binding

			- Configure static label binding:

				- mpls static binding ipv4 PFX MASK LABEL-OPTIONS

				- Where one of the LABEL-OPTIONS is required:

				- LBL binds a prefix to a local incoming label

				- input LBL is the same as a plain label

				- output NXT-HOP {explicit-null | implicit-null | LBL}

			- Examples:

				- mpls static binding ipv4 10.0.0.0 255.0.0.0 55

				- mpls static binding ipv4 10.0.0.0 255.0.0.0 output 10.0.0.1 155

		- Static cross connects

			- For LSP midpoints that support MPLS forwarding, but not label distribution via LDP or RSVP:

			- mpls static crossconnect IN-LBL OUT-INT NXT-HOP  {OUT-LBL | explicit-null | implicit-null}

		- VRF-Aware Static

			- For VRF on PE to a customer network prefix (VPNv4)

			- mpls static binding ipv4 vrf VRF    PFX MASK (input LBL | LBL}

	- Advertisement Filter

		- Control which labels are generated globally based on prefix-list or allowing only host routes. Only a single prefix-list can be configured:

		- mpls ldp label   allocate global {prefix-list LIST | host-routes}

	- Receive Filter

		- Control the prefixes for which labels will be accepted per-neighbor:

		- mpls ldp neighbor [vrf VRF] RID labels accept ACL

	- Allocation Control

		- mpls ldp advertise-labels OPTIONS

			- vrf VRF specifies the VRF for label advertisement

			- interface INT specifies the interface for label advertisement of an interface address

			- for ACL specifies which destinations should have their labels advertised

			- to ACL specifies by RID to which LDP neighbors the labels should be sent

### VRF

- VRF Lite

	- OSPF

		- When OSPF is used with VRFs, checks are performed when LSAs are received for loop prevention when the PE is performing mutual redistribution between OSPF and BGP. This is not needed with VRFs when the router is not acting as a PE.

		- router ospf PID vrf VRF  
		    capability vrf-lite

		- This command causes the DN bit to be ignored which allows Type 3 LSAs with the DN bit set to be used. Likewise, the tag inside Type 5 and Type 7 LSAs is ignored instead of not being used when the tag is the same as the VPN tag.

- RD

	- Configured under customer VRF on PE:

		- {ip vrf NAME | vrf definition NAME}   rd VALUE

		- Where VALUE is in the format of ASN:NN or IP:ASN

- RT

	- Configured under customer VRF on PE:

		- {ip vrf NAME | vrf definition NAME}   route-target {import | export | both} VALUE

		- Where VALUE is in the format of ASN:NN or IP:ASN

- Interface Assignment

	- PE Interfaces are assigned to VRFs in interface configuration mode:

		- int INT   {ip vrf forwarding | vrf forwarding} VRF

		- The IP address is removed and must be re-applied.

- Route Limiting

	- Define the maximum number of routes that can be contained in the VRF:

		- ip vrf VRF   maximum routes NUM WARN-%

- Internet Access  / Common Services

	- Static From Global

		- Static routing on the PE:

		- ip route vrf VRF 0.0.0.0 0.0.0.0 NEXT-HOP global ip route CE-LOOP CE-MASK CE-INT CE-INT-IP ip route vrf VRF CE-LOOP CE-MASK CE-INT-IP

		- Example: Internet gateway outside IP is 192.168.67.1 in the PE global routing table. Link between PE and CE is 192.168.10.1 (PE interface e0/0) and 192.168.10.2 (CE). CE has loopback 1.1.1.1/32.

		- ip route vrf VRF 0.0.0.0 0.0.0.0 192.168.67.1 global ip route 1.1.1.1 255.255.255.255 e0.0 192.168.10.2 ip route vrf VRF 1.1.1.1 255.255.255.255 192.168.10.2

		- The global static route on the PE must be known to the Internet gateway, possibly through redistribution of static routes into BGP.

		- Reference: https://www.cisco.com/c/en/us/support/docs/multiprotocol-label-switching-mpls/mpls/24508-internet-access-mpls-vpn.html

	- NAT

		- Configured on PE router:

		- ip route vrf CUST 0.0.0.0 0.0.0.0 INET-INT INET-NXT-HOP global  interface INET-INT   ip nat outside  interface VRF-INT   ip vrf forwarding CUST   ip nat inside  ip access-list standard CUST_PFX   permit IP WC  ip nat inside source list CUST_PFX interface INET-INT vrf CUST overload

		- Where INET-INT is the Internet-facing interface on the PE, and the INET-NXT-HOP is the next-hop IP of the router connecting to the Internet.

	- Common Services VRF

		- Accomplished through route-target import and export. The Services VRF imports and exports it's own route-target value. The Customer VRFs import the Services VRF route-target value, and the Services VRF imports the Customer VRF route-target. This does not allow for overlapping IP addresses without using NAT.

		- To add scalability, all customers requiring access to the Services VRF can use the same route-target export value, then the Services VRF only requires configuration of a single route-target import value. 

- Route Leaking  / Extranet

	- Import/Export Maps allow leaking between VRF and global:

		- ip vrf VRF   {import | export} ipv4 unicast map ROUTE-MAP

	- Import/Export maps also provide a greater level of control as to the routes imported or exported into a VRF. For example with MPLS L3VPN you can specify that only certain routes from the customer's VPN will be installed at a certain site.

	- Another use case for import/export maps is to set other attributes such as communities upon import or export.

### PE-PE

- In addition to configuring the vpnv4/vpnv6 AF to enable L3VPN, remember that (extended) communities are required and are not sent by default.

- router bgp ASN   no bgp default ipv4-unicast   neighbor IP remote-as ASN   neighbor IP activate   address-family vpnv4 unicast     neighbor IP send-community extended     neighbor IP activate

### PE-CE

- Static

	- Basic PE Configuration:

	- ip route vrf VRF PFX MASK NEXT_HOP  router bgp ASN   address-family ipv4 vrf VRF     redistribute static     redistribute connected

- RIPv2

	- Basic PE Configuration:

	- router rip   version 2   address-family ipv4 vrf VRF     version 2     no auto-summary     network PE-CE_LINK     redistribute bgp ASN metric {HOPS | transparent}  router bgp ASN   address-family ipv4 vrf VRF     redistribute connected     redistribute rip

- OSPF

	- Basic PE Configuration:

	- router ospf PID vrf VRF   network IP WC area AREA   redistribute bgp ASN subnets  router bgp ASN   address-family ipv4 vrf VRF     redistribute connected     redistribute ospf PID match internal external 1 external 2

	- DN bit

		- Per RFC 4576, when a Type 3, 5 or 7 LSA is sent from a PE to a CE, the DN bit must be set, and must be cleared in all other LSA types.

		- When the PE receives from the CE a Type 3, 5 or 7 LSA with the DN bit set, the LSA must not be used during OSPF route calculation. The LSA is not translated into a BGP route. The DN bit is ignored in all other LSA types.

	- Sham Link

		- Used when OSPF sites of the same area are also connected via backdoor links. Without the sham link, the backdoor is always chosen because of the MPLS OSPF SuperBackbone (intra-area vs inter-area).

		- interface loNUM   ip vrf forwarding VRF   ip address IP 255.255.255.255  router ospf PID vrf VRF   area AREA sham-link SRC-IP DST-IP

		- Optional authentication, cost, ttl-security

		- The SRC-IP and DST-IP should ideally be loopbacks /32 on the PEs, and should not be advertised into OSPF

	- Domain ID

		- Configured on PE to determine what type of LSA to originate (Inter-Area or External) based on whether the domain ID matches or not

		- router ospf PID vrf VRF  
		    domain-id 1.2.3.4

		- You can also remove the domain-id with:  
		  domain-id null

	- Domain Tag

		- Used on the PE when redistributing BGP back into OSPF. Default value is based on BGP ASN of the MPLS backbone. If BGP redistribution results in Type 5 or Type 7 LSA, the tag is set automatically so that if another PE receives the LSAs with the same tag value, they are ignored. You can set the tag manaully also:

		- router ospf PID vrf VRF  
		    domain-tag NUM

- EIGRP

	- Basic PE Configuration:

	- router eigrp ASN   address-family ipv4 vrf VRF     network PFX WC     redistribute bgp ASN metric BW DL RL LD MTU     autonomous-system ASN  router bgp ASN   address-family ipv4 vrf VRF     redistribute connected     redistribute eigrp

	- SoO

		- Enables support for EIGRP backdoor links. Configured on the PE:

		- route-map SOO   set extcommunity soo ASN:NN  interface INT   ip vrf forwarding VRF   ip vrf sitemap SOO

- BGP

	- Basic PE Configuration:

	- router bgp PE-ASN   address-family ipv4 vrf VRF     neighbor IP remote-as CE-ASN     neighbor IP activate

	- as-override

		- Compare remote ASN with ASN stored in the end of the of the AS_PATH. If the ASNs match, the ASN in the AS_PATH is replaced with the local router's ASN.

		- neighbor IP as-override

		- Typically used on the PE side of MPLS L3VPN

	- allowas-in

		- Accept prefixes with the local AS in the AS_PATH:

		- neighbor IP allowas-in [NUM]

		- Where NUM is an optional value of the number of local AS number occurrences. The default is 3

		- Commonly used with MPLS L3VPN for sites using the same BGP ASN.

	- SoO

		- Configured on PE in VRF:

		- neighbor IP soo VALUE

		- Where VALUE is an extended community

		- The value can also be set in a route-map:

		- set extcommunity soo VALUE

		- The value can also be set in a BGP peer-policy template:

		- router bgp ASN  template peer-policy NAME   soo VALUE  address-family ipv4 vrf VRF   neighbor IP remote-as ASN2    neighbor IP activate   neighbor IP inherit peer-policy NAME

		- This is useful in situations where there are backdoor links and the as-override feature is used.

### MPLS Ping / Traceroute

- TTL propagation, TTL is copied from the IP header by default.

- no mpls ip propagate-ttl [forwarded | local]

- Where no forwarded prevents traceroute from showing hops for forwarded packets which hides the structure of the MPLS network from customers but not the provider, and no local prevents traceroute from showing hops only for local packets

- MPLS Ping/Traceroute regular mode:

- {ping | traceroute} mpls OPTIONS

- Extended mode:

- {ping | traceroute}   mpls   OPTIONS

## DMVPN / IPsec

### IPsec Site-to-Site

- IKE Phase 1

	- ISAKMP Policy

		- Negotiation begins by agreement of both peers on a common shared IKE policy, which defines a combination of security parameters:

		- crypto isakmp policy PRIORITY   encryption ENCR   hash HASH   authentication pre-share   group DH   lifetime SEC

		- PRIORITY is from 1 - 10000, with 1 being the highest. The initiating peer sends all policies, and the and the remote peer attempts to find a match by local priority.

		- ENCR is des (default), 3des, aes, aes 192, aes 256

		- HASH is sha (default), sha256, sha384, md5

		- DH is the Diffie-Hellman group, 1 (default), 2, 5, 14, 15, 16, 19, 20, 24, with higher numbers offering stronger cryptographic properties.

		- SEC is the lifetime seconds, with 86400 (1 day) default.

		- The default ISAKMP identity of the peer is the IP address, but can be changed to the hostname. IPs can be associated with a mask to allow a range. Additionally, 0.0.0.0 can be used to allow all peers using the same PSK.

	- PSK

		- By IP:

			- crypto isakmp key KEY address IP

		- By Host:

			- crypto isakmp identity hostname ip host HOST IP crypto isakmp key KEY hostname HOST

- IKE Phase 2

	- Transform Set

		- crypto ipsec transform-set NAME TRANS1 [TRANS2...]   mode {transport | tunnel}

		- Where one or more TRANS are transforms such as esp-aes 192, esp-sha384-hmac, etc. 

	- Crypto ACL

		- Define source traffic to be encrypted to particular destinations. The destination must have mirrored ACLs:

		- ip access-list extended A_TO_B   permit ip SRC WC DST WC

		- Peer:

		- ip access-list extended B_TO_A   permit ip DST WC SRC WC

	- Crypto Map

		- Define map:

			- crypto map A_TO_B local-address INT crypto map A_TO_B SEQ ipsec-isakmp   set peer B   set transform-set NAME   match address A_TO_B

			- Crypto map options:

			-   set security-association lifetime SEC | KB   set pfs GROUP

		- Apply to interface:

			- interface INT   crypto map A_TO_B

- GRE over IPsec

	- Crypto Map

		- Permits dynamic routing protocols; traffic is encrypted after it is GRE encapsulated.

		- Configured similar to regular IPsec tunnel, but ACL permits GRE instead:

		- ip access-list extended A_TO_B   permit gre host A host B

		- Crypto map is applied to tunnel source interface.

	- Crypto Profile

		- crypto ipsec profile NAME   set transform-set TSET  interface tun NUM   tunnel protection ipsec profile NAME

	- IPv6 over IPv4 GRE tunnel protection

		- Enable ipv6 unicast-routing and configure an IPv6 address on the GRE tunnel interface. Also works with ipv6 multicast-routing.

### VTI

- SVTI

	- crypto isakmp policy 1   encr ENCR   hash HASH   auth pre-share   group DH  crypto isakmp key KEY address 0.0.0.0 0.0.0.0  crypto ipsec transform-set SET1 TRANS1 TRANS2  crypto ipsec profile PROF   set transform-set SET1 [SET2...]  interface tun NUM   tunnel mode ipsec ipv4   tunnel protection ipsec profile PROF

	- Wildcard PSK is 0.0.0.0 address or mask, static PSK is with individual IP address.

- DVTI

	- Spoke:

		- interface tun NUM   ip unnumbered LOOP   tunnel mode ipsec ipv4   tunnel protection ipsec profile PROF

	- Hub:

		- interface virtual-template NUM type tunnel   ip unnumbered LOOP   tunnel mode ipsec ipv4   tunnel protection ipsec profile PROF  crypto isakmp profile PROF   keyring {KEY | default}   match identity address 0.0.0.0   virtual-template NUM  crypto keyring KEY   pre-shared-key address IP1 key PASS   pre-shared-key address IP2 key PASS2

	- Features applied to physical interface are applied after crypto. Features applied to the tunnel interface are applied before crypto.

### DMVPN

- NHRP

	- Activation

		- Tunnel interface:

		- tunnel mode gre [multipoint]

			- Where multipoint is always configured on the hub, and also configured on the client when not in Phase 1.

		- ip address OVERLAY MASK

		- tunnel source INT

		- ip nhrp network-id NUM

			- The network-id is a local value (like OSPF PID) and not carried in NHRP messages. It does not have to match between devices, but it is best practice to do so.

		- Optional tunnel key NUM command is used for GRE, not NHRP.

	- Mapping

		- NHRP replaces ARP for resolution. When creating static routes out of a DMVPN hub interface, you must include the next-hop IP, and you cannot specify only the outgoing interface because it relies on the client NHRP mapping. The UNDERLAY-IP is also known as the NBMA address.

		- Spokes (Next Hop Clients):

			- ip nhrp nhs HUB-OVERLAY-IP ip nhrp map HUB-OVERLAY-IP HUB-UNDERLAY-IP

		- Multicast:

			- ip nhrp map multicast {dynamic | UNDERLAY-IP}

		- Unique Flag:

			- ip nhrp registration no-unique

			- Controlled by spoke in registration request and set by default. If a unique mapping for a particular IP is already in the NHS NHRP cache and another NHC tries to register the same IP, the NHS rejects it until the unique entry expires. If a spoke receives its NBMA address via DHCP, you should enable this command:

	- Authentication

		- ip nhrp authentication PASS

	- Timers

		- Resolutions are valid for 7200 seconds (2 hours) by default. Set on the NHS tunnel interface:

			- ip nhrp holdtime SEC

		- Spokes send registration requests every 1/3 of the hold-time seconds, but you can adjust the value with the following command, where the registration requests are sent on the SEC value:

			- ip nhrp registration timeout SEC

	- Filtering

		- Generate requests based on ACL:

			- ip nhrp interest ACL

			- Useful to control which spokes to resolve

- Common Phase Issues

	- RIPv2, OSPF, EIGRP: Neighborship requires mapped multicast or static neighbors

	- OSPF: Set MTU on tunnel to avoid mismatches. Hub cannot use default tunnel point-to-point mode because it must maintain multiple adjacencies. For broadcast/nonbroadcast network types, ensure spokes do not become the DR.

- Phase 1

	- General

		- Spoke routers use regular GRE tunnels which specify the hub as the destination. No spoke-to-spoke traffic, all traffic passes through the hub. Spokes send NHRP Registration requests, but not NHRP Resolution requests

	- RIPv2

		- Hub Tunnel: Disable Split-Horizon

	- OSPF

		- OSPF spokes cannot form adjacency with each other (TTL=1). Hub should use P2MP

		- Spokes can use P2P if the hub is set to P2MP, but ensure timers match. Spokes can also use P2MP.

		- Hub can use ip ospf database-filter all out for efficiency

	- BGP

		- Use eBGP Multihop between spokes

	- EIGRP

		- Hub Tunnel: Disable Split-Horizon

		- Spokes: Configure as EIGRP stubs for efficiency

- Phase 2

	- General

		- No summarization or default routing from the hub because the next-hop value in routing updates must be preserved. All spokes know about all other spokes in the topology. Direct tunnels are formed between spokes, but not routing adjacencies. Spokes are configured as mGRE like the hub. CEF resolves only the next-hop via NHRP, not the full routing prefixes, which is why the next-hop must not be changed.

	- RIPv2

		- Disable split-horizon. Third-party next-hop is automatic and not configurable.

	- EIGRP

		- Disable split-horizon and next-hop-self

	- OSPF

		- Requires broadcast/nonbroadcast network type, and only hub should be elected DR.

- Phase 3

	- General

		- Summarization / default routing from hub allowed because the hub does not have to preserve the next-hop values in routing updates

		- Enable DMVPN Phase 3 with ip nhrp shortcut on spoke and hub tunnel interfaces, and ip nrhp redirect on the hub tunnel interface.

		- When summarization is used on the hub, and the spoke is redirected to a more-specific route, the route appears in the spoke's routing table as an NHRP route.

- QoS

	- Preclassify

		- Enable QoS classification of packets before GRE encapsulation:

		- interface tun NUM   qos pre-classify

- IPsec

	- Configuration is similar to GRE over IPsec where the IPsec profile is applied to the tunnel interface. Example configuration:

	- crypto isakmp policy 1   encr aes 128   hash sha256   auth pre-share   group 16  crypto isakmp key KEY address 0.0.0.0  crypto ipsec transform-set TRANS esp-aes 256 esp-sha512-hmac   mode transport  crypto ipsec profile PROF   set transform-set TRANS  int tun NUM   tunnel protection ipsec profile PROF

## Multicast

### Basics

- Enable on Router

	- Global:

		- ip multicast-routing

- Addressing

	- [Range: 224.0.0.0 - 239.255.255.255 (224/4)](https://www.iana.org/assignments/multicast-addresses/multicast-addresses.xhtml)

	- Local Scope: 224.0.0.0 - 224.0.0.255

		- 224.0.0.1 All Multicast Hosts

		- 224.0.0.2 All Multicast Routers

		- 224.0.0.5 OSPF All Routers

		- 224.0.0.6 OSPF Designated Routers

		- 224.0.0.10 EIGRP Routers

		- 224.0.0.9 RIPv2 Routers

		- 224.0.0.13 All PIM Routers

		- 224.0.0.22 IGMP

	- Global Scope: 224.0.1.0 - 224.238.255.255

		- Internetwork Control: 224.0.1.0 - 224.0.1.255

		- SSM: 232.0.0.0/8

		- GLOP: 233.0.0.0/8

	- Administratively Scoped: 239.0.0.0/8

- Group Membership

	- Join a group

		- Interface:

			- ip igmp join-group MCAST-IP

	- IGMP Version

		- Interface:

			- ip igmp version {1|2|3}

	- IGMP Snooping

		- Enabled by default.

			- [no] ip igmp snooping [vlan VLAN]

		- Statically configure a port as being connected to a multicast router:

			- ip igmp snooping vlan VLAN mrouter interface INT

		- Enable Immediate Leave on ports with only a single host:

			- ip igmp snooping vlan VLAN immediate-leave

	- IGMP Querier

		- IGMPv1

			- DR (highest IP) sends Queries

		- IGMPv2

			- Querier has lowest IP

	- IGMP Filter

		- Limit number of groups that can be simultaneously joined

			- Global:

				- ip igmp limit NUM

			- Per-interface:

				- ip igmp limit NUM

		- Limit which groups can be joined

			- Typically issued on downstream interface facing clients:

			- ip igmp access-group ACL

			- Standard ACL applies to all IGMP versions

			- Extended ACL applies to IGMPv3 to limit both groups and sources

	- IGMP Timers

		- Query Interval

			- How frequently is the network checked for the presence of multicast group members.

			- Interface:

				- ip igmp query-interval SEC

		- Query Timeout

			- Amount of time before IGMP querier re-election when the previously-elected querier stops responding.

			- Interface:

				- ip igmp querier-timeout SEC

		- Max Response

			- If nobody responds to an IGMP query within the timeout, a prune is sent upstream.

			- Interface:

				- ip igmp query-max-response-time SEC

		- Last Member Query

			- Interface:

				- ip igmp last-member-query-count NUM

				- ip igmp last-member-query-interval MS

		- Immediate Leave

			- When there is only a single receiver for a group on the segment

			- Interface:

				- ip igmp immediate-leave group-list ACL

- PIM DR Election

	- Preemptive, Highest Priority, Highest IP

	- Interface:

		- ip pim dr-priority NUM

- PIM DF Election

	- PIM Assert

		- Lowest AD, Lowest Metric, Highest IP

		- With hub-and-spoke, make sure hub is always elected DF or use PIM NBMA mode

		- You can cause a router to win the PIM Assert via a more-preferred static mroute

- Static Multicast Routes

	- ip mroute SRC MSK {IP | INT} [AD]

	- Creates an ordered table of entries to look up for RPF information (order of entry - enter most specific first)

- RPF Failure

	- Registration Failure

		- Verify PIM is enabled on all routers between sender and receiver

	- RPF Failure with Tunnel Interface

		- interface tun NUM  tunnel source INT  tunnel dest IP  ip pim MODE

		- If no IGP on the tunnel, static mroutes are necessary for RPF checks

		- If IGP on the tunnel, metrics may need to be adjusted or use static mroutes

### PIM-DM

- Interface:

- ip pim dense-mode

### PIM-SM

- Interface

	- ip pim sparse-mode

- Static RP

	- Global:

		- ip pim rp-address IP [ACL][override]

		- ACL lists groups mapped to the RP

		- override forces the router to retain static information even if a different RP for the group is learned via Auto-RP (Auto-RP/BSR overrides static by default)

- Auto-RP

	- Candidate RP

		- Single

			- ip pim send-rp-announce {IP | INT} scope TTL

			- Options:

				- interval SEC

				- group-list ACL

					- Standard ACL

					- permit = SM groups

					- deny = group treated as DM

		- Multiple Candidate RPs

			- Goal is combination of load balancing and redundancy. Configure specific non-overlapping entries on each RP for load balancing, followed by an overlapping generic range for redundancy.

			- Example, one RP services in order 224.0.0.0 - 231.255.255.255 and the entire 224/4. Another RP services 232.0.0.0 - 239.255.255.255, and the entire 224/4. While both RPs are active, the appropriate RP will be used depending on the more specific match.

		- Filtering Candidate RPs

			- Configured on the Mapping Agent:

			- ip pim rp-announce-filter rp-list ACL group-list ACL

			- Without rp-list all announcements containing groups matched in the group-list are matched

			- Without the group-list all updates from the RPs in the rp-list are matched

	- Mapping Agent

		- ip pim send-rp-discovery INT scope TTL [interval SEC]

		- If multiple MA's are configured, the highest IP wins

	- Auto-RP Listener

		- Allows for PIM-SM to be enabled on interfaces, and groups other than 224.0.1.39 and .40 are not allowed to use PIM-DM.

		- Global:

			- ip pim autorp listener

	- RP/MA Placement Issues

		- With hub-and-spoke, PIM NBMA mode will not work with AutoRP because it uses PIM-DM to distribute RP information.

		- Ensure MA is placed behind hub, not at spoke

	- Sparse-Dense-Mode

		- Interface:

			- ip pim sparse-dense-mode

		- Enables support for dense-mode flooding of Auto-RP advertisements

		- Allow only Auto-RP groups to use DM flooding:

			- no ip pim dm-fallback

- BSR

	- Candidate BSR

		- ip pim bsr-candidate INT PRIORITY

		- Multiple BSR Candidates: Higher Priority, Higher IP

	- Candidate RP

		- ip pim rp-candidate INT

			- group-list ACL

			- priority NUM

			- interval SEC

		- Multiple RP Candidates

			- Lowest Priority (0 default), Highest hash value for a group, Highest IP

			- Verify selected RP with show ip pim rp-hash GROUP

### SSM

- Global:

	- ip pim ssm {default | range ACL}

- IGMPv3 must be enabled on receiving interfaces:

	- interface INT  ip pim sparse-mode  ip igmp version 3  ip igmp join GROUP source LOCAL-IP

### BiDir PIM

- Global (enable on all routers or routing loops can occur):

	- ip pim bidir-enable

- RP:

	- Static:

		- ip pim rp-address IP [ACL] bidir

	- Auto-RP:

		- ip pim send-rp-announce INT scope TTL group-list ACL bidir

	- BSR:

		- ip pim rp-candidate INT group-list ACL bidir

### Filtering

- Multicast Boundary

	- Interface:

		- ip multicast boundary ACL [in | out] [filter-autorp]

		- filter-autorp inspects auto-rp messages and filters those not matching the ACL, and ACL must be standard. in / out does not work with filter-autorp

		- Standard ACL inspects IGMP and PIM messages

		- Extended ACL has format SRC WC GRP MSK

- Auto-RP Boundary Filtering

	- Set TTL on ip pim send-rp-discovery and ip pim send-rp-announce commands

- BSR Boundary Filtering

	- Interface:

		- ip pim bsr-border

	- BSR messages are no longer flooded or received on the link

- PIM Accept Register Filtering

	- Configured on RP to specify sources allowed to register

		- ip pim accept-register list ACL

		- Where ACL has the following format: permit ip SRC WC GRP WC

	- Example: allow host 1.2.3.4 to send traffic to any multicast group via the RP:

		- permit ip host 1.2.3.4 224.0.0.0 15.255.255.255

- PIM Accept RP Filtering

	- Prevents unwanted groups or RPs from becoming active

	- Global:

		- ip pim accept-rp {IP | auto-rp} [ACL]

		- The IP or auto-rp specifies the RP to which Join/Prune will be sent

		- ACL specifies the acceptable groups

### MSDP

- Peering

	- ip msdp peer IP [connected-source INT] [remote-as ASN]

	- ip msdp originator-id INT

	- Mesh Groups

		- Mesh groups have fully-meshed MSDP connectivity among themselves. SA messages received from a peer in a mesh group are not forwarded to other peers in the same group, which reduces SA message flooding.

		- ip msdp mesh-group NAME PEER-IP

- SA state cache

	- ip msdp cache-sa-state

	- After a router forwards the SA message, it does not keep it in memory. If another member joins, it must wait for the next SA message (aka join latency) unless this command is enabled.

- Anycast RP

	- Multiple RPs with same /32 loopback

	- Multiple RPs are MSDP peers (on different IPs than the Anycast /32s)

	- Use different MSDP originator IDs on each RP

- SA Filters

	- SA origination

		- ip msdp redistribute

			- [list ACL]

			- [asn AS_PATH_ACL]

			- [route-map MAP]

	- SA filter list

		- ip msdp sa-filter {in | out} IP

			- [list ACL]

			- [route-map MAP]

			- [rp-list RP-ACL]

			- [rp-route-map RP-MAP]

- Stub Multicast

	- Identify the upstream RP that forwards SA messages:

	- ip msdp default-peer IP [prefix-list PFX]

### PIM NBMA Mode

- Treats individual neighbors on a multipoint as if they were on a separate interface. Permits spoke-to-spoke multicast, and only sends multicast to spokes with active clients. Fixes prune override problem.

### Multicast Over GRE

- interface tun NUM  tunnel source INT  tunnel dest IP  ip pim MODE

- If no IGP on the tunnel, static mroutes are necessary for RPF checks

- If IGP on the tunnel, metrics may need to be adjusted or use static mroutes

### Stub Multicast Routing

- Create downstream PIM neighbor filter on upstream router's interface facing downstream:

	- ip access-list standard ACL_PIM_DWN  deny DOWNSTREAM-IP  permit any  interface DOWNSTREAM-FACING  ip pim MODE  ip pim neighbor-filter ACL_PIM_DWN

- Configure IGMP helper on downstream router's client-facing interface(s):

	- interface CLIENT-FACING  ip pim MODE  ip igmp helper-address UPSTREAM-IP

### Multicast Helper Map

- Enables a UDP broadcast to be redirected to a multicast group

- Multicast must be enabled along the path between broadcast sources

- Ingress interface:

	- ip forward-protocol udp PORT

- Ingress router:

	- ip multicast helper-map broadcast GROUP ACL

	- Where ACL controls which broadcast packets are eligible for multicast conversion

	- Example: permit ip udp any any eq PORT

	- Use same PORT as configured on ingress interface

- Egress interface:

	- ip forward-protocol udp PORT

	- ip directed-broadcast

	- or:

	- ip broadcast-address IP

- Egress router:

	- ip multicast helper-map GROUP BCAST-IP ACL

	- Where GROUP is the same as configured on ingress, and BCAST-IP is the particular subnet's broadcast address

	- This command is configured on all multicast receiving interfaces, not the interface facing the destination

## IPv6

### Enable globally on router:

- ipv6 unicast-routing

### Addressing

- Static

	- Regular:

		- ipv6 address ADDR/LEN

	- Link-Local:

		- ipv6 address fe80::X link-local

		- Useful to prevent changing of the link-local address if the interface changes somehow.

	- Unique-Local:

		- ipv6 address fc00::X/64

		- Format: FC00 (7 bits) + Unique ID (41 bits) + Link ID (16 bits) + 64-bit Interface ID

- SLAAC

	- Router

		- Enabling ipv6 unicast-routing and an IPv6 address on an interface causes the router to send RAs automatically.

	- Client

		- Interface:

			- ipv6 address autoconfig [default]

			- Where default causes a default route to be installed toward the router. This can be issued on only a single interface on the router.

- EUI-64

	- ipv6 address 2001::/64 eui-64

- ND / RA

	- Routers send RAs for all IPv6 prefixes configured on a link. Prevent the advertisement of specific prefixes:

		- ipv6 nd prefix PFX/LEN VALID-SEC PREFERRED-SEC no-autoconfig

	- RA advertisement frequency:

		- ipv6 nd ra-interval SEC

	- RA valid lifetime:

		- ipv6 nd ra-lifetime

	- Prevent RAs for all prefixes:

		- ipv6 nd suppress-ra

- General Prefix

	- Global:

		- ipv6 general-prefix NAME {PFX/LEN | 6to4 INT}

	- Interface:

		- ipv6 address NAME 0::x/64

### Routing

- Static

	- Directly-Attached:

		- ipv6 route PFX/LEN INT

	- Fully-Specified:

		- ipv6 route PFX/LEN INT IPv6

	- Recursive:

		- ipv6 route PFX/LEN IPv6

	- Floating:

		- ipv6 route PFX/LEN INT IPv6 AD

- RIPng

	- Most commands are the same as RIPv2, except using ipv6 rip instead of ip rip

	- Interface:

		- ipv6 rip NAME enable

	- Router process:

		- ipv6 router rip NAME

- OSPFv3

	- Basic

		- ipv6 router ospf PID

		- Interface:

			- ipv6 ospf PID area AREA

	- Address Families

		- router ospfv3 PID  address-family ipv4 unicast   options  address-family ipv6 unicast   options

		- Interface:

			- ospfv3 PID area AREA {ipv4 | ipv6}

	- Prefix Suppression

		- router ospfv3 PID  prefix-suppression

		- May also be configured per-AF, and disabled per-interface

	- Most other commands are identical, just using ipv6 ospf instead of ip ospf

- EIGRPv6

	- Enabling

		- Classic

			- Global:

				- ipv6 router eigrp ASN  no shutdown

			- Interface:

				- ipv6 eigrp ASN

		- Named Mode

			- router eigrp NAME  address-family ipv6 autonomous-system ASN

	- Most other commands are identical, just using ipv6 eigrp instead of ip eigrp

- PBR

	- Configure regular route-map, match/set ipv6 criteria

	- interface INT  ipv6 policy route-map MAP

- BGP

	- router bgp ASN  address-family ipv6 unicast   neighbor IPv6 remote-as ASN   neighbor IPv6 activate

- Redistribution

	- Connected interfaces not included by default in redistribution, only routes learned through the various routing protocols. Use the include-connected option when performing redistribution.

### Transition

- 6to4 Tunnel

	- 6to4 tunnels use the 2002::/16 prefix in the format of 2002:border-router-ipv4-address::/48.  Only a single 6to4 tunnel is allowed per router.

	- The 32 bits following 2002: correspond to the IPv4 address of the tunnel source. For example, if the source IP is 10.10.10.1, the IPv6 prefix would be 2002:0A0A:0A01::/48

	- interface tunnel NUM  
	   ipv6 address IPv6/PFX  
	   tunnel source IPv4/INTERFACE  
	   tunnel mode ipv6ip 6to4

	- ipv6 route PFX/LEN tunnel NUM

- IPv6 in IPv4

	- IP Protocol 41

	- interface tunnel NUM  ipv6 address IPv6  tunnel source IP/INT  tunnel destination IP  tunnel mode ipv6ip

- GRE IPv6

	- interface tunnel NUM  
	   tunnel source INTERFACE/IPv6 ADDRESS  
	   tunnel destination IPv6 ADDRESS  
	   tunnel mode gre ipv6  
	   ipv6 address ADD/LEN

- ISATAP

	- The IPv6 address uses eui-64 because the last 32 bits of the interface identifier are constructed from the IPv4 tunnel source. Unsuppressing RA's across the tunnel allows for client autoconfiguration.

	- interface tunnel NUM  
	   ipv6 address PFX/LEN eui-64  
	   no ipv6 nd suppress-ra  
	   tunnel source IPv4/INT  
	   tunnel mode ipv6ip isatap

- Manual IPv6 Tunnel

	- interface tunnel NUM  
	   ipv6 address IPv6/LEN  
	   tunnel source INT/IPv4 ADDRESS  
	   tunnel destination IPv4 ADDRESS  
	   tunnel mode ipv6ip

- NAT-PT

	- Translate between mapped IPv6 and IPv4 addresses.

	- Globally designate /96 IPv6 prefix to use for NAT-PT

		- ipv6 nat prefix IPV6/96

	- Designate IPv6 NAT on interfaces:

		- ipv6 nat

	- Statically map addresses:

		- ipv6 nat v4v6 source IPv4 IPv6

		- ipv6 nat v6v4 source IPv6 IPv4

	- Note that this is not in the CCIE RSv5 lab, only the written exam.

### Filtering

- Only extended ACLs are supported for IPv6

- ipv6 access-list ACL

### Multicast

- Address format

	- FF always in first byte

	- 4 bit flags, bits 0 - 3 are always 0 for unicast, bit 4 is 1 if it is transient (not assigned by IANA)

	- 4 bit scope

		- 0 / 0000 Reserved

		- 2 / 0010 Link-Local

		- 1 / 0001 Node-Local

		- 5 / 0101 Site-Local

		- 8 / 1000 Organization-Local

		- 14 / 1110 Global

		- 15 / 1111 Reserved

	- SSM: ff3x::/96

- Enable / Disable

	- Global:

		- ipv6 multicast-routing

	- Interface:

		- no ipv6 pim

- ACL filtering

	- ipv6 access-list ACL  permit ipv6 SRC GRP

- IGMP replaced with MLD

	- Limit groups:

		- ipv6 mld limit

	- Join a group:

		- ipv6 mld join-group GROUP

	- Timers:

		- ipv6 mld query-interval SEC

		- ipv6 mld query-timeout SEC

		- ipv6 mld query-max-response-time SEC

- BSR

	- ipv6 pim bsr candidate rp IPv6

	- ipv6 pim bsr candidate bsr IPv6

- Embedded RP

	- Address format: FF7x:0yLL:PPPP:PPPP:PPPP:PPPP:32-bit GID

	- Bits:

		- x = scope

		- y = interface-id

		- LL = prefix length

		- P's = 64-bit RP prefix

		- Actual RP address is PPPP:PPPP:PPPP:PPPP::y/LL

	- Example:

		- Router 1:  interface int  ipv6 mld join-group ff76:0640:2001:cc1e::8

		- Router 2:  int loop1  ipv6 address 2001:cc1e::6/128  ipv6 ospf 1 area 0

## Security

### IPv4

- Storm Control

	- Allows you to limit unicast, multicast, or broadcast traffic levels on an interface.

		- interface INT  storm-control TYPE level LEVEL

	- Configure an action:

		- storm-control action {shutdown | trap}

- DHCP Snooping

	- Global

		- Enable:

			- ip dhcp snooping

			- ip dhcp snooping vlan VLAN

		- DHCP Binding Database

			- ip dhcp snooping database LOCATION [write-delay SEC]

		- Static Binding

			- Configured in global EXEC mode

			- ip dhcp snooping binding MAC vlan VLAN IP interface INT expiry SEC

	- Interface

		- Trusted interface:

			- ip dhcp snooping trust

		- Limit DHCP messages per second:

			- ip dhcp snooping limit rate MSG

	- Information Option

		- Allows DHCP requests to reference the switch ports they are received on (Option 82).

			- Enabled by default:

				- ip dhcp snooping information option

			- In L2-only configurations, the giaddr field of the DHCP packet is left empty, and IOS DHCP server does not allocate an address unless it is disabled:

				- no ip dhcp snooping information option

		- Allow-Untrusted on upstream aggregation switches

			- ip dhcp snooping information option allow-untrusted

		- Global Remote ID:

			- ip dhcp snooping information option format remote-id string NAME

		- Interface Circuit ID:

			- ip dhcp snooping vlan NUM information option format-type circuit-id string NAME

		- Interaction with DHCP Server

			- Switch may insert option but leave giaddr field set to zero, which IOS DHCP server may interpret as invalid. Override with global ip dhcp relay information trust-all or interface ip dhcp relay information trusted

	- MAC verification:

		- Untrusted ports automatically verify that the source MAC and DHCP client hardware address match. This can be disabled:

			- no ip dhcp snooping verify mac-address

- DHCP Authorized ARP

	- Secure ARP table entries to DHCP leases:

		- ip dhcp pool POOL  update arp

	- Enable authorized ARP on the interface. This causes the interface to stop dynamic ARP learning, and it must rely on static entries or bindings in the DHCP server. The DHCP server periodically sends ARP requests and only authorized devices can respond. Unauthorized responses are blocked by the DHCP server.

		- interface INT  arp authorized

- Port Security

	- Enabled per-interface. Default is to allow one MAC address with violation mode shutdown

	- interface INT  switchport mode {access | trunk}  switchport port-security  switchport port-security maximum NUM [vlan VLAN]  switchport port-security mac-address MAC [vlan VLAN]  switchport port-security mac-address sticky [vlan VLAN]  switchport port-security violation MODE  switchport port-security aging OPTION

	- Remember to account for interaction with protocols such as HSRP that use a vMAC

- ACLs

	- standard

		- Match based on source IP address and WC

	- extended

		- Match on src/dest IP/subnet, ports, options, etc

	- time-based

		- Define time range globally:

			- time-range TR_NAME  <times>

		- Reference in ACL:

			- ip access-list extended ACL_TIME  deny ip any any time-range TR_NAME

	- reflexive

		- Entries are generated automatically and temporarily allows traffic into the network if a session was established from the inside out first. The permit reflect keywords enable the reflexive ACL feature. For example, you could create an ACL that allows a host on the outside to ping a host on the inside, but only if the inside host contacted the outside host first (and within the specified timeout period)

		- Requires extended named ACL

		- ip access-list extended ACL_REFLEX  permit ip any any reflect NAME [timeout SEC]

		- Where NAME is the name of the new reflexive ACL

		- Use the evaluate keyword to nest a reflexive ACL inside an extended ACL

		- ip access-list extended ACL_EXT  permit icmp any any  evaluate ACL_RFLX

	- ARP

		- arp access-list NAME  permit ip host IP mac host MAC [log]

- PACL

	- PACLs take precedence over VACLs

	- interface INT  {ip | mac} access-group ACL {in | out}

- VACL

	- Create ACL to reference

		- IP/IPv6 and MAC ACLs

	- Create a VLAN access-map

		- vlan access-map VAM_NAME SEQ  match {ip | ipv6 | mac} address ACL  action ACTION

		- If you configure an IP/IPv6 ACL but do not reference a MAC ACL, non-IP/IPv6 traffic still passes

	- Apply the filter globally

		- vlan filter VAM_NAME vlan-list VLANs

		- Filter must be re-applied if there is a configuration change

		- Filters are ingress

- Protected Ports

	- A subset of private VLANs, switch ports configured as protected cannot communicate with each other on the same switch (this does not apply between switches though).

	- interface INT  switchport access vlan VLAN  switchport mode access  switchport protected

- Private VLANs

	- Requires VTPv3 or VTP transparent mode

	- Community VLAN is secondary, and member ports can communicate with other devices in the same community VLAN, and promiscuous ports in the primary VLAN

		- vlan NUM  private-vlan community

	- Isolated VLAN is secondary, and member ports can communicate only with promiscuous ports in the primary VLAN

		- vlan NUM  private-vlan isolated

	- Primary VLAN is configured as such, and is associated with the secondary PVLANs.

		- vlan NUM  private-vlan primary  private-vlan association VLANs

	- PVLAN promiscuous ports are configured as such with the switchport mode, and are mapped between the primary and secondary VLANs.

		- interface INT  switchport mode private-vlan promiscuous  switchport private-vlan mapping PRI-VLAN {add | remove} SEC-VLAN-LIST

	- PVLAN host ports are configured as such with the switchport mode, and are associated with the primary and secondary VLANS.

		- interface INT  switchport mode private-vlan host  switchport private-vlan host-association PRI-VLAN SEC-VLAN

	- Inter-VLAN routing requires mapping on the SVI

		- interface PRI-VLAN  private-vlan mapping [add | remove] SEC-VLAN-LIST

- IP Source Guard

	- Requires DHCP snooping to be enabled, but can use static bindings as well:

		- ip dhcp snooping

		- ip source binding MAC vlan VLAN IP interface INT

	- Enabled per-interface:

		- ip verify source [port-security]

		- The port-security keyword requires the switch port to be configured for port-security, and packets are filtered based on both source IP and MAC addresses.

- Dynamic ARP Inspection

	- Relies on the DHCP snooping database, unless ARP ACLs are configured exclusively.

		- ip dhcp snooping

		- arp access-list ACL_NAME  permit ip host IP mac host MAC [log]

	- Enable globally per-VLAN:

		- ip arp inspection vlan VLANS

	- Apply ARP ACLs:

		- ip arp inspection filter ACL_NAME vlan VLANS

	- Optionally configure trusted interfaces:

		- interface INT  ip arp inspection trust

	- Optionally limit the rate of incoming ARP packets:

		- interface INT  ip arp inspection limit rate PPS

	- Optionally perform further validations:

		- ip arp inspection validate OPTIONS

- Filter fragmented packets

	- ip access-list extended ACL_NO_FRAG  deny ip any any fragments  permit ip any any

- Packet Logging with ACLs

	- Add the log keyword to the end of an ACL to generate a syslog message when the ACL is matched. This causes the packet to be process-switched.

	- The log-input keyword also logs the input interface and source MAC

	- Globally adjust how many hits a logged ACL must get before a log message is generated:

		- ip access-list log-update threshold HITS

	- Globally adjust the number of process-switched packets allowed for logging in milliseconds. For example, with a setting of 1000, only one packet per second will be logged.

		- ip access-list logging interval MS

- IP Event Dampening

	- Applied at the interface level, and applies to all subinterfaces.

		- dampening [options]

	- Options include:

		- Half-life period, default 5 seconds

		- Reuse-threshold, default 1000

		- Suppress-threshold, default 2000

		- Restart-penalty, default 2000

		- Max-suppress-time, default 20 seconds

	- Example, half-life 30 seconds, reuse threshold 1500, suppress threshold 10000, max suppress time 120 seconds:

		- interface INT  dampening 30 1500 10000 120

- uRPF

	- Interface:

		- ip verify unicast source reachable-via {rx | any} [ACL]

		- Strict mode enabled with rx keyword

		- Loose mose enabled with any keyword

- Directed Broadcasts and UDP Forwarding

	- Directed broadcasts are disabled by default, but can be re-enabled and pointed to a different IP address:

		- interface INT  ip directed-broadcast  ip broadcast-address IP

	- UDP broadcasts can be redirected to a particular IP address, and individual UDP protocols can be disabled globally.

		- [no] ip forward-protocol udp PROTOCOL

		- interface INT  ip helper-address IP

- Filtering with NBAR

	- Example: blocking certain files in HTTP requests

	- class-map match-all CM_EXT  match protocol http url "*.exe|*.msi"  policy-map PM_HTTP  class CM_EXT  interface INT  service-policy output PM_HTTP

- Proxy ARP

	- For devices in the same IP subnet, but not in the same data link layer network. Enabled by default. When disabled, the device responds to ARP only if it is the target IP, or if a static ARP alias is configured.

	- Disable per-interface:

		- interface INT  
		   no ip proxy-arp

	- Disable globally:

		- ip arp proxy disable

- TCP Keepalives

	- Terminate old TCP connections globally:

		- service tcp-keepalives-in

		- service tcp-keepalives-out

- Misc

	- Block ICMP redirects on an interface:

		- no ip redirects

	- Prevent SMURF attacks on an interface:

		- no ip directed-broadcast

	- Disable sending of ICMP unreachable messages on an interface (useful for slowing down port scans):

		- no ip unreachables

### IPv6 First Hop

- RA Guard

	- Configure global policy:

		- ipv6 nd raguard policy RA_POLICY  device-role {host | router}  [match ipv6 access-list ACL]  [match ra prefix-list PFX]  [trusted-port]

	- Apply policy to interface:

		- ipv6 nd raguard attach-policy RA_POLICY

	- Optionally apply to VLAN:

		- vlan configuration VLAN  ipv6 nd raguard attach-policy RA_POLICY

- DHCPv6 Guard

	- Globally configure policy:

		- ipv6 dhcp guard policy DG_POLICY  device-role {client | server}  [match server access-list ACL]  [match reply prefix-list PFX]  [trusted-port]

	- Attach to interface:

		- ipv6 dhcp guard attach-policy DG_POLICY [vlan VLANS]

	- Optionally attach to VLANs:

		- vlan configuration VLAN  ipv6 dhcp guard attach-policy DG_POLICY

- Binding Table

	- ipv6 neighbor binding [options]

- Device Tracking

	- Uses the binding table as a source to verify host liveliness:

		- ipv6 neighbor tracking [retry-interval NUM]

- ND Inspection/Snooping

	- Configure global policy:

		- ipv6 nd inspection policy ND_POLICY  device-role {host | monitor | router | switch}  [options]

	- Option apply to interface:

		- ipv6 nd inspection attach-policy ND_POLICY [vlan VLANS]

	- Option apply to VLAN:

		- vlan configuration VLAN  ipv6 nd inspection attach-policy ND_POLICY

- IPv6 Source Guard

	- Globally create policy:

		- ipv6 source-guard policy SG_POLICY  [deny global-autoconf]  [permit link-local]

	- Attach to interface:

		- ipv6 source-guard attach-policy SG_POLICY

- PACLs

	- Works in combination with general IPv6 traffic filtering on an interface:

		- switchport mode {access | trunk} access-group mode prefer {port | vlan} ipv6 traffic-filter ACL in

### IPv6 Traffic Filtering

- IPv6 ACLs are exclusively extended

	- ipv6 access-list ACL_IPV6  <criteria>

- ACL can be applied at the interface:

	- ipv6 traffic-filter ACL {in | out}

### Device Access Control

- Line

	- ACL applied to line to control access based on direction. Inbound represents connections to the router, outbound represents connections from the router.

		- line LINE  access-class ACL {in | out}

	- Related, you can control username access by ACL as well.

		- username NAME access-class ACL

- Password Encryption

	- Encrypts passwords from the show running-config view to prevent shoulder-surfing:

		- service password-encryption

- SNMP

	- v2c access controlled by communities and ACLs:

		- snmp-server community NAME MODE [ACL]

	- Access can be further locked down to defined views:

		- snmp-server view NAME OID-TREE {included | excluded}

		- snmp-server community COMM name VIEW [ro | rw]

- MPP

	- AAA Exec Authorization

		- aaa new-model aaa authorization exec default local line LINE  authorization exec default

	- AAA Local Command Authorization

		- aaa new-model aaa authorization exec default local privilege {exec | configure | interface} level LEVEL COMMAND line LINE  authorization exec default

	- IOS Login Enhancements

		- Global login commands:

			- login block-for SEC attempts TRIES within SEC

			- login quiet-mode access-class ACL

				- The ACL specifies an exclusion to the quiet-mode

			- login on-failure log every ATTEMPTS

			- login on-success log

			- login delay SEC

		- Requires AAA/local database for interface:

			- interface INT  login local

	- Role-Based CLI

		- Requires aaa new-model. Command sets are associated with user-defined views, which can contain other views.

		- To create a view, switch to the root view from privileged EXEC mode:

			- enable view configure terminal

		- Create the view, set the password, and define the commands:

			- parser view NAME  secret PASSWORD  commands exec include [all] COMMAND  view NAME2

		- Switch to the view from privileged EXEC mode:

			- enable view NAME

		- A superview contains multiple views:

			- parser view P_SVIEW superview  view P_VIEW1  view P_VIEW2

	- MPP interface designation:

		- control-plane host  management-interface INT allow PROTOCOLS

		- This locks down the selected protocols so they are accessible only from the designated interface.

### CoPP

- ICMP Messages Rate

	- Global:

		- ip icmp rate-limit OPTIONS

- Control Plane Host

	- Define a policy-map and apply it inbound:

		- control-plane host  service-policy input PM_NAME

### AAA with Local Database

- aaa new-model

- username USER password PASS

- username USER privilege LEVEL

- privilege exec level LEVEL COMMAND

- aaa authentication login {default | LIST-NAME} local

- aaa authorization exec {default | LIST-NAME} local

- aaa authentication username-prompt PROMPT

- aaa authentication password-prompt PROMPT

- line LINE  login authentication default  authorization exec default

### Key Chains

- Definition

	- key chain KEYS  key NUM   key-string PASSWORD   cryptographic-algorithm ALG

- Key Rotation

	- Key rotation is facilitated by setting overlapping send-lifetime and accept-lifetime under the individual keys

## QoS

### CoS and DSCP mapping

- Create a table-map to map the values:

	- table-map TM_NAME  map from COS1 to DSCP1  map from COS2 to DSCP2

	- Where COS and DSCP are actual values. The map itself is simply a table of numbers, so you can reverse the mapping by reversing the numbers.

- Reference the table-map in a policy-map:

	- policy-map PM_NAME  class class-default   set cos dscp table TM_NAME

### Classification

- Criteria matched inside a class-map

	- class-map [match-all | match-any] CM_NAME  match CRITERIA

	- match-all is default

	- You can match everything except for the specified criteria within a class-map clause with the not keyword:

		- class-map CM_NAME  match not CRITERIA

- Defined classes are referenced in policy-map

	- policy-map NAME   class CM_NAME

### NBAR

- Enables matching on application-level data

	- match protocol PROTOCOL [options]

	- match protocol attribute

- Identify custom applications on an interface:

	- ip nbar custom NAME CRITERIA

- Protocol discovery on interface:

	- ip nbar protocol-discovery

### Marking

- Markings are set inside classes within a policy-map:

	- policy-map PM_NAME  class class1   set precedence NUM  class class2    set dscp NUM  class class3    set cos NUM  class class4

- ECN

	- Explicit Congestion Notification is a function of WRED in IOS.

		- policy-map PM_NAME  class class-default   random-detect ecn

- Tunnel ToS

	- You can mark some tunnel types with a ToS value on the tunnel interface:

		- interface tunnel NUM  tunnel tos NUM

		- For example, 184 marks DSCP EF. ToS value is derived from DSCP value x4 (46x4=184)

### Shaping

- Shape Average

	- Limits the transmission rate to the CIR

		- shape average CIR-BPS [BC-BITS] [BE-BITS]

		- shape average percent %

- Shape Peak

	- Allows transmission rate above CIR, but traffic above CIR could be dropped if there is congestion

		- shape peak CIR-BPS [BC-BITS] [BE-BITS]

		- shape peak percent %

### Policing

- Configured with police command inside class inside policy-map

- policy-map PM_NAME  class CLASS   police OPTIONS

	- Single-Rate Two-Color

		- Conform and Exceed actions defined

	- Single-Rate Three-Color

		- Conform, Exceed, and Violate actions defined

	- Dual-Rate Three-Color

		- Conform, Exceed, and Violate actions defined

		- CIR and PIR defined

### Congestion Management (queuing)

- CBWFQ

	- bandwidth is used to reserve a minimum amount of bandwidth in the output queue relative to the configured interface bandwidth

		- policy-map PM_NAME  class CLASS   bandwidth {KBPS | percent NUM | remaining percent NUM}

- Fair-Queue

	- Flow-based fair queuing can be enabled in the default class only, and enables preferential treatment to interactive flows. You can optionally specify the number of queues to reserve.

		- policy-map PM_NAME  class class-default   fair-queue [NUM]

- Priority

	- priority enables LLQ and creates a strict PQ which allows delay-sensitive traffic to be dequeued and sent before packets in other queues. During congestion, traffic above the defined rate is discarded.

		- policy-map PM_NAME  class CLASS   priority {KBPS | percent NUM}

### Sub-Rate Ethernet

- CAR

	- Rate-limiting configured on the interface:

		- rate-limit {input | output} BPS NORMAL-BURST MAX-BURST conform-action ACTION exceed-action ACTION 

		- Configure input and output as separate statements

		- You can also rate-limit by ACL

- Tagged Subinterfaces

	- With tagged subinterfaces, you can apply a parent shaping policy and then apply queuing policies underneath.

	- policy-map SUB_POLICY  class one   options  class two   options  policy-map PARENT  class class-default   shape average 10000000     service-policy SUB_POLICY  interface g0/0.100  encap dot1q 100  service-policy output PARENT

### Congestion Avoidance

- WRED

	- Configured with random-detect under policy-map

		- random-detect precedence IPP MIN MAX MPD

		- ECN:

			- random-detect ecn

- TCP ECN

	- Globally enable support for receiving TCP ECN signaling: 

		- ip tcp ecn

### QoS Policy Propagation via BGP (QPPB)

- Enables interaction with the FIB (CEF table) based on received BGP attributes such as communities.

- Define route-map to match criteria and set IPP:

	- route-map RM_QBBP  match community NUM  set ip precedence NUM

- Reference in BGP table-map:

	- router bgp ASN  table-map RM_QPPB

- Configure traffic lookup on the incoming interface. The bgp-policy command enables classification based on FIB policy entries:

	- interface INT  bgp-policy {source | destination} {ip-prec-map | ip-qos-map}

	- Where source or destination indicates whether to use the source or destination IP address in the incoming packet, and ip-prec-map and ip-qos-map indicates whether to use IP precedence bits, or a defined QoS group ID.

## Network Infrastructure

### Device Management

- SSH

	- hostname NAME ip domain-name DNAME crypto key gen rsa gen mod BITS ip ssh version 2

	- ip ssh timeout SEC

	- ip ssh authentication-retries NUM

	- You can configure SSH without setting a domain name by generating a crypto usage key:

	- crypto key gen rsa usage-keys label LABEL mod BITS ip ssh rsa keypair-name LABEL

- HTTP/S

	- ip http server ip http secure-server ip http max-connections NUM ip http path URL ip http port PORT ip http access-class ACL ip http authentication local ip http secure-port PORT

	- ip http client source-interface INT ip http client username NAME ip http client password PASS

- SCP

	- Requires AAA

	- aaa new-model aaa authentication login default local aaa authorization exec default local ip scp server enable

- FTP Client

	- ip ftp source-interface INT ip ftp username USER ip ftp password PASS

- TFTP

	- tftp-server FILE alias NAME [ACL]

	- ip tftp source-interface INT

- Lines

	- Individual lines can have their configurations overridden. For example, configuring line vty 0 4 with options, and then configuring just line vty 0, vty 0 will inherit the main config and override it with the supplemental config

	- Basic

		- line vty START END

			- session-timeout MIN

			- exec-timeout MIN SEC

			- absolute-timeout MIN

			- login METHOD (local, etc)

			- transport input [telnet] [ssh]

			- logout-warning SEC

			- access-class ACL {in | out}

	- Login without login local:

		- aaa new-model aaa authentication login default local aaa authentication enable default none

		- Related: Do not prompt for credentials on console:

		- aaa authentication login console none line con0  priv level 15  login authentication console

	- Messages:

		- vacant-message X MESSAGE X

		- refuse-message X MESSAGE X

		- busy-message X MESSAGE X

	- Execute command on connect

		- autocommand EXEC-COMMAND

		- Example, telnet to another system:

		- autocommand telnet IP PORT

	- Rotary groups allow you to connect to the VTY line starting on port 3000 + the rotary group

		- Example, assign VTY line 2 to port 3010:

		- line vty 2  rotary 10

	- Message / address suppression

		- Suppress telnet messages:

			- ip telnet quiet

		- Hide telnet IP addresses:

			- ip telnet hidden addresses

		- Hide telnet hostnames:

			- ip telnet hidden hostnames

	- Menus

		- Manual Invocation:

			- enable menu MENU

		- Automatic Invocation:

			- username USER autocommand menu MENU

		- Creation

			- menu NAME title ^C Menu Text ^C menu NAME text 1 Option Number One menu NAME command 1 COMMAND menu NAME text 2 Option Two menu NAME command 2 COMMAND

		- Other options:

			- Clear screen before displaying menu:

			- menu NAME clear-screen

			- Exit menu:

			- menu NAME command NUM menu-exit

			- Default command that is run if the user presses Enter without specifying an item:

			- menu NAME default NUM

			- Go to a sub-menu:

			- menu NAME1 command NUM menu NAME2

			- Hidden menu item:

			- menu NAME command NUM COMMAND

			- Status line includes hostname, line number, terminal type:

			- menu NAME status-line

			- Require login for a command:

			- menu NAME options NUM login

- RSH

	- Running commands on a router to gather information without needing to connect and disconnect.

	- Global:

		- ip rcmd rsh-enable ip rcmd remote-host LOCAL-USER REMOTE-IP REMOTE-USER [enable [level]]

	- Client:

		- rsh IP /user REMOTE-USER COMMAND

- Configuration Change Notification / Logging

	- archive  log config   logging enable   logging size BYES   notify syslog   [hidekeys]

- Configuration Archive / Rollback

	- archive  path URL  write-memory  time-period SEC

	- configure replace FILE [force]

- Banners

	- motd

		- banner motd X MESSAGE X

	- login

		- banner login X MESSAGE X

	- exec

		- banner exec X MESSAGE X

	- Tokens

		- $(hostname)

		- $(domain)

		- $(line)

		- $(line-desc)

- Exec Aliases

	- Configured in privileged EXEC mode:

		- alias {mode} ALIAS COMMAND

	- Example:

		- alias exec ipr show ip route

- Auto-Install via DHCP

	- Client-side

		- Obtain DHCP client ID by enabling DHCP debugging and then enable DHCP on the interface:

		- debug dhcp detail conf t interface INT  ip address dhcp

		- Look for "Client-ID hex dump" in the debug output: 636973636f2d303065302e316562382e656237332d457430

	- Server-side

		- ip dhcp pool POOL  host IP MASK  client-identifier CLIENT  bootfile FILE.cfg  option 150 ip TFTP-SERVER  default-router IP

		- The client-identifier was obtained from the client-side step. Add two 0's to the beginning, and separate every four hex digits with a dot:  client-identifier 0063.6973.636f.2d30.3065.302e.3165.6238.2e65.6237.332d.4574.30

- Configuration Generation Performance Enhancement

	- Improves speed of nonvolatile generation command, such as show running-config, by caching them in memory. Useful for very large configurations with many interfaces.

	- parser config cache interface

- Configuration NVRAM compression

	- Globally enable compression of the startup configuration file on nvram:

	- service compress-config

### SNMP

- v2c

	- Define community strings:

		- snmp-server community NAME {ro | rw} [ACL]

	- Location / contact

		- snmp-server location STRING

		- snmp-server contact STRING

	- Interface index persistence across reloads:

		- snmp-server ifindex persist

	- Persistence of MIBs across reloads:

		- Save to nvram: with EXEC command:

		- snmp mib persist MIB

		- write mib-data

	- Enable long interface aliases up to 256 characters:

		- snmp ifmib ifalias long

	- Remote reboot capability:

		- snmp-server system-shutdown

- v3

	- snmp-server group GROUP v3 [auth | no auth | priv] [read|write|notify VIEW] [ACL]

	- snmp-server view VIEW MIB {included | excluded}

	- snmp-server user USER GROUP v3 {access | auth | encrypted} OPTIONS

- Traps / Informs

	- snmp-server enable traps OPTIONS

	- snmp-server host IP [inform version VER] COMMUNITY

### Logging

- local

	- logging console LEVEL

	- logging monitor LEVEL

	- Display in XML format:

		- logging console xml

- syslog

	- logging source-interface INT

	- logging host IP [transport OPTIONS]

	- logging trap LEVEL

	- logging origin-id string NAME

- buffered

	- logging buffered BYTES LEVEL

- timestamp

	- service timestamp [log | debug] [uptime | datetime [year msec]]

- rate-limit

	- logging rate-limit DESTINATION [console] [all] NUM [except LEVEL]

- File

	- logging persistent filesize BYTES logging persistent url LOCATION

### FHRP

- HSRP

	- standby GROUP ip VIP standby GROUP timers HELLO HOLD standby GROUP preempt standby GROUP authentication md5 key-string PASS standby GROUP name NAME standby GROUP priority NUM standby GROUP track NUM [decrement NUM]

		- preempt enables deterministic behavior (e.g. highest priority / highest IP is Active), otherwise the first speaker to become Active remains so until it fails.

		- name is used in conjunction with follow and lets a secondary HSRP group track the status and use the timers of the master group on an interface.

		- track NUM uses object tracking to determine HSRP status, and can optionally decrement the current priority by the specified amount.

	- HSRP vMAC becomes 0000.0c07acXX where XX is the GROUP in hexadecimal. HSRP updates are sent to 224.0.0.2.

		- mac-address lets you specify the HSRP vMAC

		- Interface standby use-bia uses the interface MAC as the VIP vMAC

	- HSRP v2 allows for 4095 groups, The vMAC is 0000.0c9f.fXXX, where XXX is the GROUP in hexadecimal. HSRPv2 updates are sent to 224.0.0.102. HSRPv1 and v2 cannot both run on the same interface, though different versions can run on different interfaces.

		- interface INT  standby version 2

- VRRP

	- vrrp GROUP ip VIP vrrp GROUP authentication MODE PASSWORD vrrp GROUP priority NUM vrrp GROUP timers {advertise [msec] NUM | learn} vrrp GROUP preempt [delay minimum SEC] vrrp GROUP track NUM [decrement NUM]

- GLBP

	- glbp GROUP ip VIP glbp GROUP timers HELLO HOLD glbp GROUP name NAME glbp GROUP authentication {text PASS | md5 key-chain KEYS | md5 key-string PASS} glbp GROUP priority NUM [delay minimum SEC] glbp GROUP weighting MAX glbp GROUP weighting track NUM [decrement NUM] glbp GROUP forwarder preempt [delay minimum SEC] glbp GROUP load-balancing METHOD

- IRDP

	- ICMP Router Discovery Protocol allows hosts to find their default gateway based on router discovery advertisements.

		- Defaults:

		- Broadcast advertisements

		- Max interval between advertisements: 600 seconds

		- Min interval between advertisements: 450 seconds

		- Hold time: 1800 seconds

		- Router preference: 0

	- Client needs an IP address on a connected interface, and the following global commands:

		- no ip routing ip gdp irdp [multicast]

	- Advertising router is configured on the client-facing interface:

		- ip irdp [multicast]

	- Advertising router interface options:

		- Changing the maxadvertinterval changes both minadvertinterval and holdtime, so always adjust that value first.

			- ip irdp maxadvertinterval SEC ip irdp minadvertinterval SEC ip irdp holdtime SEC

		- When multiple routers are advertising on the segment, you can set a preference (higher preferred):

			- ip irdp preference NUM

		- Like other FHRPs, you can specify a VIP to advertise:

			- ip irdp address IP [PREF]

### IPv6 RS/RA Redundancy

- HSRPv2

	- standby version 2 standby GROUP ipv6 {IPV6 | autoconfig}

- GLBP

	- glbp GROUP ipv6 IPV6

- VRRPv3

	- Global:

		- fhrp version vrrp v3

	- Interface:

		- vrrp GROUP address-family ipv6  OPTIONS

### NTP

- Master

	- Router becomes authoritative NTP time source with specified stratum level.

		- ntp master LEVEL

		- ntp source INT

	- NTP server can broadcast or multicast updates on interfaces.

		- ntp {broadcast | multicast GROUP}

- Client

	- ntp server IP [prefer]

	- NTP client can listen for broadcasts or multicasts on an interface.

		- ntp {broadcast client | multicast client GROUP}

- v3 / v4

	- v3 is default, v4 is compatible with v3 but enables IPv6 support. Most commands are the same as v3.

		- ntp peer IPV6 version 4

		- ntp server IPV6 version 4

- Authentication

	- ntp authenticate ntp authentication-key NUM md5 PASSWORD ntp trusted-key NUM ntp peer IP key NUM [source INT]

- Access Control

	- ntp access-group {serve-only | peer} ACL

### NAT

- Common:

	- no-alias keyword prevents the global address from responding to ICMP pings

	- The add-route keyword adds a static route back in, which may be necessary due to NAT order of operations: Inside > Outside = route first, Outside > Inside = NAT first

- Static NAT

	- ip nat inside source static LOCAL GLOBAL

	- ip nat outside source static GLOBAL LOCAL

- Static PAT

	- ip nat inside source static tcp LOCAL PORT GLOBAL PORT

	- ip nat outside source static tcp GLOBAL PORT LOCAL PORT

- Dynamic NAT

	- ip nat pool POOL START-IP END-IP {netmask MASK | prefix-length LEN}  ip access-list standard ACL_NAT  permit SOURCE WC  ip nat {inside | outside} source list ACL_NAT pool POOL

- Overloading

	- ip nat inside source SOURCE {interface INT | pool POOL} overload

- Policy NAT

	- NAT with route-maps allows mappings to different inside global IPs for the same inside local IP

	- route-map RM_LINK1  match interface INT1 route-map RM_LINK2  
	   match interface INT2  ip nat inside source static IP1 IP2 route-map RM_LINK1 ip nat inside source static IP1 IP3 rotue-map RM_LINK2

- NAT ALG

	- ip nat service OPTIONS

- Overlapping subnets

	- NAT is being performed in both directions.

	- Example IP 100.0.0.1/24 on one side of NAT, 100.0.0.4 on the other side. IPs 1.1.1.1 and 3.3.3.3 used as intermediaries.

	- ip nat inside source static 100.0.0.1 1.1.1.1 ip nat outside source static 100.0.0.4 3.3.3.3 add-route

	- The add-route keyword adds a static route back in, which is necessary due to NAT order of operations: Inside > Outside = route first, Outside > Inside = NAT first

	- Watch for recursive routing requirements

- TCP load distribution

	- ip nat pool POOL prefix-length LEN type rotary  address START-IP END-IP  ip access-list extended LB  permit tcp any host IP [eq PROTOCOL]  ip nat inside destination list LB pool POOL

- NAT Virtual Interface

	- Regular NAT routes first Inside > Outside, and NAT's first Outside > Inside. NVI eliminates this behavior.

	- Interface:

		- ip nat enable

- NAT Default Interface

	- All traffic received on the outside interface not matching an existing dynamic translation is statically forwarded to an inside host. Useful for applications that have different outbound and inbound traffic flows.

	- ip nat inside source list ACL interface INT overload ip nat inside source static IP interface INT

- Static Extendable NAT

	- Configure multiple static mappings for the same local or global IP address.

	- ip nat inside source static IP1 IP2 extendable ip nat inside source static IP1 IP3 extendable

- Reversible NAT

	- Extendable entries are created automatically with route-maps which prevents an external connection from outside to inside, but the reversible keyword creates automatic reverse one-to-one mappings.

	- ip nat inside source route-map RM_MAP pool POOL reversible

### DHCP

- Server

	- Basic

		- ip dhcp excluded-address LOW-IP [HIGH-IP] ip dhcp pool POOL  network NET MASK [secondary]  domain-name DOMAIN  dns-server IP1 [IP2...]  default-router IP1 [IP2...]  bootfile FILENAME  next-server IP1 [IP2...]  option CODE {ascii STRING | hex STRING | ip IP}  lease TIME

	- Manual bindings (pool config):

		- host IP [mask | LEN] client-identifier UID hardware-address MAC [PROTOCOL] client-name NAME

		- Determine client ID on server with debug dhcp detail, look for DHCPDISCOVER from CLIENT ID

		- Example Reserving for a Specific Host:

		- Configure client to send a client-id:

		- interface INT  ip dhcp client client-id ascii NAME  ip address dhcp

		- Set up the initial pool for the client on the server:

		- ip dhcp pool NAME  host IP MASK

		- Debug DHCP to find the client ID:

		- debug ip dhcp server packet

		- Look for client ID in DHCPDISCOVER message

		- Modify DHCP pool with client ID:

		- ip dhcp pool NAME  client-identifier ID

	- Ping:

		- Specify number of ping packets to send before issuing lease:

			- ip dhcp ping packets NUM

			- Set to 0 to disable

		- Specify how long to wait for ping reply (500ms default):

			- ip dhcp ping timeout MS

	- Ignore BOOTP requests

		- Global:

			- ip dhcp bootp ignore

- Relay

	- Interface:

		- ip helper-address IP ip dhcp relay information option-insert [none] ip dhcp relay information trusted ip dhcp relay information trust-all ip dhcp relay information policy-action {drop | keep | replace} ip dhcp relay information option subscriber-id ID

- Stateful/Stateless DHCPv6

	- Stateful

		- ipv6 dhcp pool NAME  dns-server IPV6  domain-name DOMAIN  interface INT  ipv6 dhcp server POOL [rapid-commit]  ipv6 nd managed-config flag

	- Stateless

		- ipv6 dhcp pool NAME  dns-server IPV6  domain-name DOMAIN  interface INT  ipv6 dhcp server POOL [rapid-commit]  ipv6 nd other-config flag

- DHCPv6 prefix delegation

	- ipv6 dhcp pool POOL  prefix-delegation {pool POOL | IPV6/LEN} [lifetime TIME]

- Client

	- ip address dhcp

	- ip dhcp client OPTIONS

	- ip dhcp client client-id ID

- Disable DHCP globally

	- no service dhcp

### IP SLA

- Operations

	- DHCP

		- ip sla NUM  dhcp IP [source-ip SRC]

	- DNS

		- ip sla NUM  dns TARGET name-server IP [source SRC]

	- FTP

		- ip sla NUM  ftp get URL [mode MODE] [source SRC]

	- HTTP

		- ip sla NUM  http {get | raw} URL [OPTIONS]

	- ICMP echo

		- ip sla NUM  icmp-echo DST [source SRC]   frequency SEC   request-data-size BYTES   timeout MS   tos TOS

	- ICMP jitter

		- ip sla NUM  icmp-jitter DST [SRC] [num-packets NUM] [interval MS]   frequency SEC   request-data-size BYTES   timeout MS   tos TOS   percentile OPTION %

	- MPLS

		- ip sla NUM  mpls lsp {ping | trace} {ipv4 | pseudowire} OPTIONS

	- ICMP path-echo

		- ip sla NUM  path-echo DST [source-ip SRC]   frequency SEC   request-data-size BYTES   timeout MS   tos TOS

	- Path jitter

		- ip sla NUM  path-jitter DST [SRC] [num-packets NUM] [interval MS] [targetOnly]   frequency SEC   request-data-size BYTES   timeout MS   tos TOS

	- TCP-Connect

		- ip sla NUM  tcp-connect IP PORT [source SRC] [control {enable | disabled}]

	- UDP echo

		- ip sla NUM  udp-echo DST PORT [source-ip SRC source-port PORT]   data-pattern HEX   frequency SEC   request-data-size BYTES   timeout MS   tos TOS

	- UDP jitter

		- ip sla NUM  udp-jitter DST PORT [SRC] [num-packets NUM] [interval MS]   frequency SEC   request-data-size BYTES   timeout MS   tos TOS   percentile OPTION %

	- VoIP

		- ip sla NUM  voip {rtp | delay} {OPTIONS}

- Common Options

	- ToS value

		- The ToS value can be specified with several of the operations. The ToS value can be obtained by multiplying the IPP value by 32, or the DSCP value by 4.

		- Possible ToS values include 0, 32, 64, 96, 128, 160, 192, 224

	- NTP

		- Time-related options, such as jitter, require an NTP relationship, whether peer or master/client.

- Schedule

	- ip sla schedule NUM [life LIFE] [start-time START] [recurring]

- IP SLA responder

	- Enables more accurate statistics

	- ip sla responder

### Object Tracking

- Interface

	- track NUM interface INT line-protocol

	- track NUM interface INT ip-routing

	- track timer interface SEC

- IP route

	- track NUM ip route PFX/LEN reachability

	- track NUM ip route PFX/LEN metric threshold  threshold metric (up NUM [down NUM] | down NUM [up NUM]}

	- track timer ip route SEC

- IP SLA

	- track NUM ip sla NUM [state]

	- track NUM ip sla NUM reachability

- Tracking List

	- track LIST-NUM list boolean {and | or}  object NUM [not]

	- track LIST-NUM list threshold weight  object NUM [weight NUM]  threshold weight {[up NUM] [down NUM]}

	- track LIST-NUM list threshold percentage  object NUM  threshold percentage {[up NUM] [down NUM]}

### Netflow

- v5

	- Support BGP-AS information and flow sequence numbers

- v9

	- Supports multicast, MPLS, BGP Next-Hop, flexible extensible format

- Local retrieval

	- show ip flow interface show ip cache flow show ip cache verbose flow show ip flow export show ip flow top-talkers

- Top talkers

	- ip flow-top-talkers  top NUM  sort-by {bytes | packets}  cache-timeout MS  match CRITERIA

- Sampler

	- Basic configuration:

		- flow-sampler-map SM_NAME  mode random one-out-of NUM  interface INT  flow-sampler SM_NAME

	- Policy-map configuration:

		- flow-sampler-map FS_NAME  mode random one-out-of NUM  class-map CM_NAME  match CRITERIA  policy-map PM_NAME  class CM_NAME   netflow-sampler FS_NAME  interface INT  service-policy input PM_NAME

- Flexible Netflow

	- Enables specification of captured fields

		- flow record FR_NAME  description DESC  match CRITERIA  flow monitor FM_NAME  description DESC  record FR_NAME  interface INT  ip flow monitor FM_NAME {input | output}

	- Sampling:

		- sampler S_NAME  description DESC  mode {deterministic | random} 1 out-of NUM  interface INT  ip flow monitor FM_NAME sampler S_NAME {input | output}

- Export

	- ip flow-export destination DST PORT ip flow-export version VER ip flow-export source INT interface INT  ip flow {[ingress] [egress]}

		- Older alternative:

		- interface INT  ip route-cache flow

		- ip flow ingress allows enabling per interface and sub-interface

		- ip route-cache flow is enabled on the main interface and then is automatically enabled on subinterfaces. You cannot selectively enable/disable subinterfaces with this command.

### IP Accounting

- Configured on the interface to keep track of byte counts per src/dst.

	- interface INT  ip accounting [precedence {input|output}]

- Account based on MAC address:

	- interface INT  ip accounting mac-address {input|output}

- Global options:

	- ip accounting-threshold NUM ip accounting-list ACL ip accounting-transits NUM

### EEM

- Architecture

	- EEM server

		- Internal process that handles interaction between publishers and subscribers

	- Event publisher

		- Event Detector

		- CLI, Netlow, SNMP, syslog, timers, counters, and more

	- Event subscriber

		- Event Policy defines event and actions to be taken

		- Policy types:

			- Applets - defined in CLI

			- Scripts - defined in TCL

		- Process:

			- Select Event

			- Define detector options

			- Optionally define variables

			- Optionally define actions

- Applets

	- event manager applet APP_NAME  event EVENT  action 1.0 ACTION  action 2.0 ACTION

	- Numbering is lexiconological - 10.0 comes after 1.0, but before 2.0. Ordering can include letters: action a, action b, action 1.0a, etc.

- KRON command schedule

	- event manager applet CRON_EXAMPLE  event timer cron name TIMER cron-entry "11 22 * * 1-5"  action 1.0 cli command "COMMAND"

- Interface Events

	- event manager applet INT_EXAMPLE  event tag 1.0 event track 1 state down  action 1.0 cli command "COMMAND"

- Syslog Events

	- event manager applet SYSLOG trap  event tag 1.0 syslog pattern "PATTERN"  action 1.0 syslog msg "EVENT"  action 2.0 cli command "COMMAND"

- CLI Events

	- event manager applet CLI  event cli pattern "PATTERN" OPTIONS

	- sync {yes | no} indicates if policy should be executed synchronously before the CLI command executes

	- skip {yes | no} option indicates if the CLI command should be executed. Required if sync no, should not be specified if sync yes

	- <$_cli_msg> variable stores the CLI command that triggered the applet

- Exit Status

	- action NUM set exit_status 1

	- Allows the matched event (such as a command input) to be executed, 0 = don't execute

- Periodic Scheduling

	- event manager applet SCHEDULE trap  event timer watchdog name TIMER time SEC  action 1.0 cli command "COMMAND"

- Run applet on-demand

	- event manager run APPLET

- Examples

	- Trigger Syslog message when case-insensitive 'ospf' is entered on the CLI:

	- event manager applet OSPF  event cli pattern "[Oo][Ss][Pp][Ff]" sync yes  action 1.0 syslog msg "<$_cli_msg> OSPF Command Entered"  action 2.0 set exit_status 1

	- Configure commands at boot:

	- event manager applet INITIAL_VLAN  
	   event timer cron cron-entry "@reboot"  
	   action 1.0 cli command "enable"  
	   action 2.0 cli command "conf t"  
	   action 3.0 cli command "vlan 10,20,30,40,60,70"  
	   action 4.0 cli command "exit"  
	   action 5.0 cli command "vtp domain CISCO360"  
	   action 6.0 cli command "end"

	- Bring an interface up if another interface goes down by monitoring syslog messages, and send an email message:

	- event manager applet INT_UP_DOWN  event syslog pattern ".*UPDOWN.*InterfaceNum.*down"  action 1.0 cli command "enable"  action 2.0 cli command "conf t"  action 3.0 cli command "interface INT"  action 4.0 cli command "no shutdown"  action 5.0 cli command "end"  action 6.0 mail server "MAIL_IP" to "[someone@somewhere.com](mailto:someone@somewhere.com)" from "[someoneelse@somewhere.com](mailto:someoneelse@somewhere.com)" subject "Interface X down" body "Backup interface enabled"

## Troubleshooting

### Embedded Packet Capture

- Configure an ACL to match traffic to capture:

	- ip access-list extended PCAP   permit ip any host 10.1.1.1   permit ip host 10.1.1.1 any

- Configure capture buffer parameters in EXEC mode:

	- monitor capture buffer BUFFER size KB max-size ELEMENT TYPE

	- Where BUFFER is the name, KB is the total size in Kbytes, ELEMENT is the max size in bytes of each entry (think MTU), and TYPE is either linear (default) or circular buffer.

- Attach the filter:

	- monitor capture buffer BUFFER filter access-list PCAP

- Define the capture point:

	- monitor capture point ip cef CPOINT INT DIR

	- Where CPOINT is the capture point name, INT is the interface, and DIR is the traffic direction

- Associate the capture point with the buffer:

	- monitor capture point associate CPOINT BUFFER

- Start/Stop the capture:

	- monitor capture point {start | stop} CPOINT

- Export capture to PCAP file:

	- monitor capture buffer BUFFER export [tfp://IP/file.pcap](tfp://IP/file)

### Conditional Debug

- Conditional debugging allows limiting the debug output to various limited conditions. When the conditions are set, certain debug commands (but not all) will then be limited to displaying only matching conditions.

	- debug condition CRITERIA

	- Example: debug condition interface INT

	- Remove: no debug condition NUM

- You can also limit some debugs by ACL

	- ip access-list 1 permit 10.1.1.1 0.0.0.0 debug ip packet detail 1

### Route-Map Processing

- Normally the route map stops processing after the first match and the route map process exits. You can cause the route-map to jump to a different clause after processing with the continue command.

	- route-map NAME   continue [SEQ]

### Test TCP (ttcp)

- Hidden, undocumented EXEC command to generate TCP traffic between two devices, sender and receiver. Not supported on all platforms.

### ? as part of a password

- Press Ctrl-V following by the ? to enter a ? without triggering the context-aware help.

### TCP Small Servers

- Enable:

	- service tcp-small-servers

- Echo back what is entered:

	- telnet IP echo

- Discard what is entered:

	- telnet IP discard

- Generate stream of ASCII data:

	- telnet IP chargen

- Return system date and time:

	- telnet IP daytime

- Exit session:

	- Ctrl-Shift-6 + x

### TCL ping test

- Enter the TCL shell from EXEC mode:

	- tclsh

- Enter the syntax and IP addresses to ping. Upon entering the final line, the script will execute:

	- foreach ip { IP1 IP2 IP3 } { ping $ip }

- Exit the TCL shell when finished:

	- tclquit

- Cancel in-progress commands with:

	- Ctrl-Shift-6 + x

- You can substitute for other EXEC commands as well, such as traceroute.

