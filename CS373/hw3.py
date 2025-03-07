from CSVPacket import Packet, CSVPackets
import sys, re

IPProtos = [0 for x in range(256)]
numBytes = 0
numPackets = 0

csvfile = open(sys.argv[1].'r')

class ipMap(object):
    def __init__(self, ipaddr):
        self.addr = ipaddr
        self.ports = []
    def addPort(self,pType,pNum):
        port = "%s/%d"%(pType,pNum)
        if port not in self.ports:
            self.ports.append(port)
        def totalPorts(self):
            return len(self.ports)
        def portList(self):
            return self.ports
        
portNumMax = 65535
if __name__ == "__main__":
    if "-stats" in sys.argv: # clean up with dictionary
        portListTCP = [0]*portNumMax
        postListUDP = [0]*portNumMax
        for pkt in CSVPackets(csvfile):
            if (pkt.proto & 0xff) == 6:
                portListTCP[pkt.tcpdport]+=1
            if (pkt.proto & 0xff) == 17:
                portListUDP[pkt.udpdport]+=1
        for i in range(1,portNumMax)
            if portListTCP[i] != 0:
                print "TCP Port: %d -> %d" %(o,[portListTCP[i]])
        for i in range(1,portNumMax)
            if postListUDP[i] != 0:
                print "UDP Port: %d -> %d" %(o,[postListUDP[i]])
    elif "-countip" in sys.argv:
        ipAddrList = {}
        for pkt in CSVPackets(csvfile):
            tcp = str(pkt.ipsrc)
            udp = str(pkt.ipdst)
            if not tcp in ipAddrList:
                ipAddrList[tcp] = (1,(pkt.proto & 0xff))
            elif tcp in ipAddrList:
                count = ipAddrList[tcp][0]
                ipAddrList[tcp] = (count + 1,(pkt.proto & 0xff))

            if not udp in ipAddrList:
                ipAddrList[udp] = (1,(pkt.proto & 0xff))
            elif udp in ipAddrList:
                count = ipAddrList[udp][0]
                ipAddrList[udp] = (count + 1,(pkt.proto & 0xff))
        for key,val in sorted(ipAddrList.iteritems(), key=lambda (k,v): (v,k), reverse=True):
            print "%s : usage: %d : proto: %d" %(key,val[0],val[1])
    elif "connto" in sys.argv:
        ipObjs = {}
        bcastAddr = re.compile('.*/.255$')#ignore broadcast addresses
        for pkt in CSVPackets(csvfile):
            ipdst = str(pkt.ipdst)
            if not ipdst in ipObjs and not bcastAddr.match(ipdst):
                ipObjs[ipdst]= ipMap(ipdst)
            if ipdst in ipObjs and (pkt.proto & 0xff) == 6:
                ipObjs[ipdst].addPort("TCP",pkt.tcpdport)
            elif ipdst in ipObjs and (pkt.proto & 0xff) == 17:
                ipObjs[ipdst].addPort("UDP",pkt.udpdport)
        for ip,obj in sorted(ipObjs.iteritems(), reverse=True):
            print "ipdst %s has %d distinct ipsrc on ports: " %(ip,obj.totalPorts)
            for port in obj.portList():
                sys.stdout.write(port +" ,")
            print("\n")