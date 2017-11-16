The db_automate resource file is a ruby script that will enumerate all *.rc files within the same directly and execute each one in linear order.

The *.rc files are the shell resource files for each MetaSploit module. To include a new module, simply create a new *.rc file and link it to the appropreiate stub ruby file (*.rb). 

The *.rb files are the brains of each resource (*.rc) file. These files are shared resources for each akin resource (*.rc) file.

Additionally, the other db_* files like db_nikto will run the associated external command only against the specific services that match the tool.

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

My example methodology is as follows:

1> Begin with a Nessus scan and then db_import *.nessus or "msf> resource db_portscan", which pulls its targets from ~/targets file.

2> "msf> resource db_verscan" <~ loops over all services in the msf database and uses nmap to preform a version scan.

3> "msf> resource db_whatweb" <~ loops over all web services in the msf database and runs whatweb against them.

4> "msf> resource db_nikto" <~ loops over all web services in the msf database and runs nikto against them. 

5> "msf> resource db_dirb" <~ loops over all web services in the msf database and runs dirb against them.

6> "msf> resource db_sqlmap" <~ loops over all web services in the msf database and runs sqlmap against them.

7> "msf> resource db_automate" <~ loops over all services in the msf database and runs all *.rc files against them.

