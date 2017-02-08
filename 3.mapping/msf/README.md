The db_automate resource file is a ruby script that will enumerate all *.rc files within the same directly and execute each one in linear order.

The *.rc files are the shell resource files for each MetaSploit module. To include a new module, simply create a new *.rc file and link it to the appropreiate stub ruby file (*.rb). 

The *.rb files are the brains of each resource (*.rc) file. These files are shared resources for each akin resource (*.rc) file.

Below is a example:

```
$ cat ftp_anonymous.rc
use auxiliary/scanner/ftp/anonymous
resource stub_ftp_rhosts.rb
```

```
$ cat stub_ftp_rhosts.rb 
<ruby>
framework.db.hosts.each do |host|
  host.services.each do |service|
    if service.name == "ftp"
      self.run_single("set RHOSTS #{host.address}")
      self.run_single("set RPORT #{service.port}")
      self.run_single("run")
    end
  end
end
</ruby>
```
