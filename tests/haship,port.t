# Create a set with timeout
0 ipset create test hash:ip,port timeout 4
# Add partly zero valued element
0 ipset add test 2.0.0.1,0
# Test partly zero valued element
0 ipset test test 2.0.0.1,0
# Delete partly zero valued element
0 ipset del test 2.0.0.1,0
# Add first random value
0 ipset add test 2.0.0.1,5
# Add second random value
0 ipset add test 2.1.0.0,128
# Test first random value
0 ipset test test 2.0.0.1,5
# Test second random value
0 ipset test test 2.1.0.0,128
# Test value not added to the set
1 ipset test test 2.0.0.1,4
# Delete value not added to the set
1 ipset del test 2.0.0.1,6
# Test value before first random value
1 ipset test test 2.0.0.0,5
# Test value after second random value
1 ipset test test 2.1.0.1,128
# Try to add value before first random value
0 ipset add test 2.0.0.0,5
# Try to add value after second random value
0 ipset add test 2.1.0.1,128
# Add port by name
0 ipset add test 2.1.0.3,smtp
# Delete port by number
0 ipset del test 2.1.0.3,25
# List set
0 ipset list test > .foo0 && ./sort.sh .foo0
# Check listing
0 ./diff.sh .foo hash:ip,port.t.list0
# Sleep 5s so that elements can time out
0 sleep 5
# List set
0 ipset list test > .foo0 && ./sort.sh .foo0
# Check listing
0 ./diff.sh .foo hash:ip,port.t.list1
# Flush test set
0 ipset flush test
# Add multiple elements in one step
0 ipset add test 1.1.1.1-1.1.1.4,80-84
# Delete multiple elements in one step
0 ipset del test 1.1.1.2-1.1.1.3,tcp:81-82
# Check number of elements after multi-add/multi-del
0 n=`ipset save test|wc -l` && test $n -eq 17
# Delete test set
0 ipset destroy test
# Create a set
0 ipset create test hash:ip,port
# Add element without specifying protocol
0 ipset add test 2.0.0.1,80
# Add "same" element but with UDP protocol
0 ipset add test 2.0.0.1,udp:80
# Test element without specifying protocol
0 ipset test test 2.0.0.1,80
# Test element with TCP protocol
0 ipset test test 2.0.0.1,tcp:80
# Test element with UDP protocol
0 ipset test test 2.0.0.1,udp:80
# Add element with GRE
0 ipset add test 2.0.0.1,gre:0
# Test element with GRE
0 ipset test test 2.0.0.1,gre:0
# Add element with sctp
0 ipset add test 2.0.0.1,sctp:80
# Test element with sctp
0 ipset test test 2.0.0.1,sctp:80
# Delete element with sctp
0 ipset del test 2.0.0.1,sctp:80
# List set
0 ipset list test > .foo0 && ./sort.sh .foo0
# Check listing
0 ./diff.sh .foo hash:ip,port.t.list2
# Delete set
0 ipset destroy test
# Create set to add a range
0 ipset new test hash:ip,port hashsize 64
# Add a range which forces a resizing
0 ipset add test 10.0.0.0-10.0.3.255,tcp:80-82
# Check that correct number of elements are added
0 n=`ipset list test|grep '^10.0'|wc -l` && test $n -eq 3072
# Flush set
0 ipset flush test
# Add an single element
0 ipset add test 10.0.0.1,tcp:80
# Check number of elements
0 n=`ipset save test|wc -l` && test $n -eq 2
# Delete the single element
0 ipset del test 10.0.0.1,tcp:80
# Check number of elements
0 n=`ipset save test|wc -l` && test $n -eq 1
# Add an IP range
0 ipset add test 10.0.0.1-10.0.0.10,tcp:80
# Check number of elements
0 n=`ipset save test|wc -l` && test $n -eq 11
# Delete the IP range
0 ipset del test 10.0.0.1-10.0.0.10,tcp:80
# Check number of elements
0 n=`ipset save test|wc -l` && test $n -eq 1
# Add a port range
0 ipset add test 10.0.0.1,tcp:80-89
# Check number of elements
0 n=`ipset save test|wc -l` && test $n -eq 11
# Delete the port range
0 ipset del test 10.0.0.1,tcp:80-89
# Check number of elements
0 n=`ipset save test|wc -l` && test $n -eq 1
# Add an IP and port range
0 ipset add test 10.0.0.1-10.0.0.10,tcp:80-89
# Check number of elements
0 n=`ipset save test|wc -l` && test $n -eq 101
# Delete the IP and port range
0 ipset del test 10.0.0.1-10.0.0.10,tcp:80-89
# Check number of elements
0 n=`ipset save test|wc -l` && test $n -eq 1
# Destroy set
0 ipset -X test
# Timeout: Check that resizing keeps timeout values
0 ./resizet.sh -4 ipport
# Counters: create set
0 ipset n test hash:ip,port counters
# Counters: add element with packet, byte counters
0 ipset a test 2.0.0.1,80 packets 5 bytes 3456
# Counters: check element
0 ipset t test 2.0.0.1,80
# Counters: check counters
0 ./check_counters test 2.0.0.1 5 3456
# Counters: delete element
0 ipset d test 2.0.0.1,80
# Counters: test deleted element
1 ipset t test 2.0.0.1,80
# Counters: add element with packet, byte counters
0 ipset a test 2.0.0.20,453 packets 12 bytes 9876
# Counters: check counters
0 ./check_counters test 2.0.0.20 12 9876
# Counters: update counters
0 ipset -! a test 2.0.0.20,453 packets 13 bytes 12479
# Counters: check counters
0 ./check_counters test 2.0.0.20 13 12479
# Counters: destroy set
0 ipset x test
# Counters and timeout: create set
0 ipset n test hash:ip,port counters timeout 600
# Counters and timeout: add element with packet, byte counters
0 ipset a test 2.0.0.1,80 packets 5 bytes 3456
# Counters and timeout: check element
0 ipset t test 2.0.0.1,80
# Counters and timeout: check counters
0 ./check_extensions test 2.0.0.1 600 5 3456
# Counters and timeout: delete element
0 ipset d test 2.0.0.1,80
# Counters and timeout: test deleted element
1 ipset t test 2.0.0.1,80
# Counters and timeout: add element with packet, byte counters
0 ipset a test 2.0.0.20,453 packets 12 bytes 9876
# Counters and timeout: check counters
0 ./check_extensions test 2.0.0.20 600 12 9876
# Counters and timeout: update counters
0 ipset -! a test 2.0.0.20,453 packets 13 bytes 12479
# Counters and timeout: check counters
0 ./check_extensions test 2.0.0.20 600 13 12479
# Counters and timeout: update timeout
0 ipset -! a test 2.0.0.20,453 timeout 700
# Counters and timeout: check counters
0 ./check_extensions test 2.0.0.20 700 13 12479
# Counters and timeout: destroy set
0 ipset x test
# Network: Create a set with timeout and netmask
0 ipset -N test hash:ip,port --hashsize 128 --netmask 24 timeout 4
# Network: Add zero valued element
1 ipset -A test 0.0.0.0,80
# Network: Test zero valued element
1 ipset -T test 0.0.0.0,80
# Network: Delete zero valued element
1 ipset -D test 0.0.0.0,80
# Network: Add first random network
0 ipset -A test 2.0.0.1,8080
# Network: Add second random network
0 ipset -A test 192.168.68.69,22
# Network: Test first random value
0 ipset -T test 2.0.0.255,8080
# Network: Test second random value
0 ipset -T test 192.168.68.95,22
# Network: Test value not added to the set
1 ipset -T test 2.0.1.0,8080
# Network: Add third element
0 ipset -A test 200.100.10.1,22 timeout 0
# Network: Add third random network
0 ipset -A test 200.100.0.12,22
# Network: Delete the same network
0 ipset -D test 200.100.0.12,22
# Network: List set
0 ipset -L test > .foo0 && ./sort.sh .foo0
# Network: Check listing
0 ./diff.sh .foo hash:ip,port.t.list3
# Sleep 5s so that elements can time out
0 sleep 5
# Network: List set
0 ipset -L test > .foo
# Network: Check listing
0 ./diff.sh .foo hash:ip,port.t.list4
# Network: Flush test set
0 ipset -F test
# Network: add element with 1s timeout
0 ipset add test 200.100.0.12,80 timeout 1
# Network: readd element with 3s timeout
0 ipset add test 200.100.0.12,80 timeout 3 -exist
# Network: sleep 2s
0 sleep 2s
# Network: check readded element
0 ipset test test 200.100.0.12,80
# Network: Delete test set
0 ipset -X test
# Network: Create a set with timeout and bitmask
0 ipset -N test hash:ip,port --hashsize 128 --bitmask 255.255.255.0 timeout 4
# Network: Add zero valued element
1 ipset -A test 0.0.0.0,80
# Network: Test zero valued element
1 ipset -T test 0.0.0.0,80
# Network: Delete zero valued element
1 ipset -D test 0.0.0.0,80
# Network: Add first random network
0 ipset -A test 2.0.0.1,8080
# Network: Add second random network
0 ipset -A test 192.168.68.69,22
# Network: Test first random value
0 ipset -T test 2.0.0.255,8080
# Network: Test second random value
0 ipset -T test 192.168.68.95,22
# Network: Test value not added to the set
1 ipset -T test 2.0.1.0,8080
# Network: Add third element
0 ipset -A test 200.100.10.1,22 timeout 0
# Network: Add third random network
0 ipset -A test 200.100.0.12,22
# Network: Delete the same network
0 ipset -D test 200.100.0.12,22
# Network: List set
0 ipset -L test > .foo0 && ./sort.sh .foo0
# Network: Check listing
0 ./diff.sh .foo hash:ip,port.t.list5
# Sleep 5s so that elements can time out
0 sleep 5
# Network: List set
0 ipset -L test > .foo
# Network: Check listing
0 ./diff.sh .foo hash:ip,port.t.list6
# Network: Flush test set
0 ipset -F test
# Network: add element with 1s timeout
0 ipset add test 200.100.0.12,80 timeout 1
# Network: readd element with 3s timeout
0 ipset add test 200.100.0.12,80 timeout 3 -exist
# Network: sleep 2s
0 sleep 2s
# Network: check readded element
0 ipset test test 200.100.0.12,80
# Network: Delete test set
0 ipset -X test
# Network: Create a set with bitmask which is not a valid netmask
0 ipset -N test hash:ip,port --hashsize 128 --bitmask 255.255.0.255
# Network: Add zero valued element
1 ipset -A test 0.0.0.0
# Network: Test zero valued element
1 ipset -T test 0.0.0.0
# Network: Delete zero valued element
1 ipset -D test 0.0.0.0
# Network: Add first random network
0 ipset -A test 1.2.3.4,22
# Network: Add second random network
0 ipset -A test 1.168.122.124,22
# Network: Test first random value
0 ipset -T test 1.2.9.4,22
# Network: Test second random value
0 ipset -T test 1.168.68.124,22
# Network: Test value not added to the set
1 ipset -T test 2.0.1.0,23
# Network: Test delete value
0 ipset -D test 1.168.0.124,22
# Network: List set
0 ipset -L test > .foo
# Network: Check listing
0 ./diff.sh .foo hash:ip,port.t.list7
# Network: Delete test set
0 ipset -X test
# eof
