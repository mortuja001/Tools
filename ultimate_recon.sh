#!/bin/bash

# ▓▓ Advanced Recon Pipeline for Bug Bounty ▓▓
# Author: Mortuja (Customized by GPT)
# Dependencies: subfinder, assetfinder, amass, dnsx, httpx, nuclei, gowitness, jq

# ===[ 0. Setup ]===
read -p "🎯 Target (company name or domain): " TARGET

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
OUTDIR="recon/${TARGET}_${DATE}"
mkdir -p "$OUTDIR"
cd "$OUTDIR" || exit

touch all_raw.txt

echo "[🔎] Starting recon for: $TARGET"
echo "[🗂️] Output directory: $OUTDIR"

# ===[ 1. crt.sh lookup ]===
echo "[📄] Fetching from crt.sh..."
curl -s "https://crt.sh/?q=%25$TARGET%25&output=json" | \
  jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u >> all_raw.txt

# ===[ 2. Subfinder, Assetfinder, Amass ]===
echo "[🔍] Running subfinder..."
subfinder -d "$TARGET" -silent >> all_raw.txt

echo "[🔍] Running assetfinder..."
assetfinder --subs-only "$TARGET" >> all_raw.txt

echo "[🔍] Running amass (passive)..."
amass enum -passive -d "$TARGET" >> all_raw.txt

# ===[ 3. Chaos DB (if API Key present) ]===
if [ -f ~/.config/chaos/chaos.key ]; then
  echo "[🌩️] Using Chaos DB via ProjectDiscovery API..."
  CHAOS_KEY=$(cat ~/.config/chaos/chaos.key)
  curl -s -H "Authorization: $CHAOS_KEY" "https://dns.projectdiscovery.io/dns/$TARGET/subdomains" | \
    jq -r '.subdomains[]' | sed "s/^/./" | sed "s/^/$(echo $TARGET | sed 's/^www\.//')/" >> all_raw.txt
fi

# ===[ 4. Deduplicate ]===
sort -u all_raw.txt > subs_unique.txt
echo "[📊] Unique subdomains: $(wc -l < subs_unique.txt)"

# ===[ 5. DNS Resolution ]===
echo "[🌐] Resolving with dnsx..."
dnsx -l subs_unique.txt -silent -a -resp -o resolved.txt
echo "[✔️] Resolved: $(wc -l < resolved.txt)"

# ===[ 6. HTTP Probing ]===
echo "[🌍] Probing with httpx..."
httpx -l resolved.txt -silent -status-code -title -o live_temp.txt
cut -d " " -f1 live_temp.txt > live.txt
rm live_temp.txt
echo "[🌟] Live domains: $(wc -l < live.txt)"

# ===[ 7. Nuclei Vulnerability Scan ]===
echo "[🚨] Running nuclei on live domains..."
mkdir -p nuclei
nuclei -l live.txt -severity critical,high,medium -o nuclei/vulns.txt
echo "[🧪] Vulns found: $(grep -c '^' nuclei/vulns.txt)"

# ===[ 8. Screenshot Live Targets ]===
echo "[📸] Taking screenshots with gowitness..."
gowitness file -f live.txt --timeout 10 --threads 10 --chromedp-path $(which gowitness)
mv gowitness-report/* . 2>/dev/null

# ===[ 9. Summary Log ]===
echo "[📝] Logging summary..."
cat << EOF > summary.txt
Recon Summary - $TARGET
Date: $DATE

Subdomains Found   : $(wc -l < subs_unique.txt)
DNS Resolved       : $(wc -l < resolved.txt)
Live HTTP Services : $(wc -l < live.txt)
Nuclei Vulns Found : $(grep -c '^' nuclei/vulns.txt)

Output Directory   : $OUTDIR
EOF

cat summary.txt

# ===[ 10. Optional Slack/Telegram Alerts ]===
# You can hook your webhook here
# curl -X POST -H 'Content-type: application/json' --data '{"text":"Recon completed for '$TARGET'"}' https://hooks.slack.com/services/XXX/XXX/XXX

echo "✅ Recon completed. Reports saved in: $OUTDIR"
