docker run -v $PWD/volume:/volume -v /dev/net/tun:/dev/net/tun --name=reno2 --cap-add=net_admin --rm -it "$@" antmicro/renode:nightly sh -c "
    set -x
    ip tuntap add tap0 mode tap
    ip link add br0 type bridge
    ip link set up dev tap0
    ip link set up dev br0
    ip link set tap0 master br0
    ip link set eth0 master br0
    ADDR=\`ip addr show scope global |grep -o '\S*/[0-9]\+'\`
    ip addr flush scope global
    ip addr add \$ADDR dev br0
    cd /volume
    python3 -m http.server 12345 &
    renode --disable-xwt --console -e 'logLevel 3 console ; logFile @/volume/log.txt ; i @/volume/rdfm-demo.resc ; s ; uart_connect sysbus.uart0'
    "
