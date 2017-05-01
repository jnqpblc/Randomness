<ruby>
framework.db.hosts.each do |host|
    self.run_single("set RHOSTS #{host.address}")
    self.run_single("run")
end
</ruby>
