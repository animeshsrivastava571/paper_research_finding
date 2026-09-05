#!/usr/bin/env bash
# Re-download and extract the paper full texts into papers/ (gitignored).
#
# Why text and not PDFs: the questions that matter in this project turn on
# method-section details — what the memory unit is, what enters the store,
# what gets dropped — which abstracts consistently misrepresent.
#
# Usage:  ./scripts/fetch_papers.sh
# Needs:  curl, python3, beautifulsoup4 (pip install beautifulsoup4)

set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p papers/raw

# arXiv IDs of the papers read end to end
IDS=(
  2605.22057   # FlyRoute — self-evolving agent profiling via data flywheel
  2605.07180   # BoundaryRouter / RouteBench — learning agent routing from early experience
  2603.22455   # SkillRouter — skill routing for LLM agents at scale
  2606.03565   # R3-Skill — query-conditioned compatibility for skill routing
  2508.07935   # SHIELDA — structured handling of exceptions in agentic workflows
  2601.19249   # GLOVE — global verifier for memory-environment realignment
)

for id in "${IDS[@]}"; do
  # arXiv HTML is versioned; try newest first and take the first real hit
  for v in v3 v2 v1 ""; do
    code=$(curl -sL -o "papers/raw/$id.html" -w "%{http_code}" "https://arxiv.org/html/$id$v")
    size=$(wc -c < "papers/raw/$id.html")
    if [ "$code" = "200" ] && [ "$size" -gt 20000 ]; then
      echo "fetched $id$v ($size bytes)"
      break
    fi
  done
done

python3 - <<'PY'
from bs4 import BeautifulSoup
import re, glob, os

for f in sorted(glob.glob('papers/raw/*.html')):
    soup = BeautifulSoup(open(f, encoding='utf-8').read(), 'html.parser')
    for tag in soup(['script', 'style', 'nav', 'footer']):
        tag.decompose()
    txt = soup.get_text('\n')
    txt = re.sub(r'\n{3,}', '\n\n', txt)
    txt = re.sub(r'[ \t]{2,}', ' ', txt)
    out = 'papers/' + os.path.basename(f).replace('.html', '.txt')
    open(out, 'w', encoding='utf-8').write(txt)
    print(f'{out}  {len(txt.split()):,} words')
PY
