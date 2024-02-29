# Showing default routes by command
    > ip route show 
# there are routes with metric like this
 >  default via 192.168.1.100 dev ens224 proto static metric 101

 >  default via 10.200.204.1 dev ens192 proto static metric 102

 >  10.200.204.0/25 dev ens192 proto kernel scope link src 10.200.204.4 metric 102

 >  192.168.1.0/24 dev ens224 proto kernel scope link src 192.168.1.117 metric 101

# In situation there are two default routes from two different interfaces
# If you want to change metric or default route through which in interface request goes
    > ip route change [purpose] via [gateway] dev [interface] metric [new_metric]
# OR
    > ip route del default via [Ip_addr_gateway]
