<ruby>
framework.db.hosts.each do |host|
  host.services.each do |service|
    if service.proto == "udp" && service.port == 5060
      self.run_single("set RHOSTS #{host.address}")
      self.run_single("set RPORT #{service.port}")
      self.run_single("run")
    end
  end
end
</ruby>
