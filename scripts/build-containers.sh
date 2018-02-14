[ -d /root/repos/contrail-container-builder ] || git clone https://github.com/Juniper/contrail-container-builder /root/repos/contrail-container-builder
cp common.env /root/repos/contrail-container-builder
cp tpc.repo.template /root/repos/contrail-container-builder
cd /root/repos/contrail-container-builder/containers && ./build.sh
