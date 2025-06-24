# 🛡️ Ultimate Recon - Company-Wide Subdomain Enumeration & Vulnerability Scanner

> Automated bug bounty reconnaissance script for security researchers & red teamers.

This script performs **end-to-end recon** for a given target (company name or domain), including:
- Passive Subdomain Enumeration (`crt.sh`, `subfinder`, `assetfinder`, `amass`)
- ChaosDB API-based Enumeration (if available)
- DNS Resolution (`dnsx`)
- HTTP/HTTPS Probing (`httpx`)
- Vulnerability Scanning (`nuclei`)
- Screenshot Capture (`gowitness`)
- Logging & Reporting

---

## 🚀 Features

✅ Accepts **company name** or **domain**  
✅ Multi-source passive enumeration  
✅ ChaosDB integration (optional API)  
✅ Resolves & probes for live HTTP(S) hosts  
✅ Auto vulnerability scanning (Critical/High/Medium)  
✅ Screenshots of live web services  
✅ Timestamped organized folders  
✅ Easily extendable for notifications & reports

---

## 📦 Requirements

Install Go-based tools:

```bash
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/tomnomnom/assetfinder@latest
go install github.com/OWASP/Amass/v3/...@latest
go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install github.com/sensepost/gowitness@latest
