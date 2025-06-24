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

Install Go tools:

```bash
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/tomnomnom/assetfinder@latest
go install github.com/OWASP/Amass/v3/...@latest
go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install github.com/sensepost/gowitness@latest

🔐 Chaos API Setup (Optional)
Get an API key from ProjectDiscovery Chaos.

Then save it to:
mkdir -p ~/.config/chaos
echo 'your_api_key_here' > ~/.config/chaos/chaos.key

🧪 Usage
chmod +x ultimate_recon.sh
./ultimate_recon.sh
Enter either a company name (e.g., uber, paypal) or a domain (e.g., example.com) when prompted.

📁 Output
Results are saved under:
recon/<targetname>_<timestamp>/
├── subs_unique.txt      # Deduplicated subdomains
├── resolved.txt         # DNS-resolved domains
├── live.txt             # Live HTTP/S endpoints
├── nuclei/vulns.txt     # Vulnerability scan results
├── screenshots/         # Captures of live domains
├── summary.txt          # Quick recon summary

📢 Optional: Slack/Telegram Notification
To enable alerting, add your webhook line at the end of the script:
# curl -X POST -H 'Content-type: application/json' \
# --data '{"text":"Recon complete for target X"}' \
# https://hooks.slack.com/services/XXXXX/XXXXX/XXXXX

🙋 Author
Script designed by Mortuja
Crafted with ❤️ & security in mind.
