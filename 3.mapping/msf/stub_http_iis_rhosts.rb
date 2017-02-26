set SSL false

<ruby>
framework.db.hosts.each do |host|
  host.services.each do |service|
    if service.info =~ /IIS/ && service.name == "http" || service.info =~ /IIS/ && service.name == "www"
      self.run_single("set RHOSTS #{host.address}")
      self.run_single("set RPORT #{service.port}")
      self.run_single("run")
    end
  end
end
</ruby>

set SSL true

<ruby>
framework.db.hosts.each do |host|
  host.services.each do |service|
    if service.info =~ /IIS/ && service.name == "https" || service.info =~ /IIS/ && service.name == "ssl/http" || service.info =~ /IIS/ && service.name == "ssl/https"
      self.run_single("set RHOSTS #{host.address}")
      self.run_single("set RPORT #{service.port}")
      self.run_single("run")
    end
  end
end
</ruby>
