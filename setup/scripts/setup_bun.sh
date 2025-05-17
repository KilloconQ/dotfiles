### scripts/setup_bun.sh
if ! command -v bun &>/dev/null; then
  curl -fsSL https://bun.sh/install | bash
fi
