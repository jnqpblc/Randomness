<ruby>
framework.db.hosts.each do |host|
  host.services.each do |service|
    if service.port == 445
      self.run_single("set RHOSTS #{host.address}")
      self.run_single("set RPORT #{service.port}")
      self.run_single("check")
    end
  end
end
</ruby>
