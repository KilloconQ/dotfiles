### scripts/setup_volta.sh
if ! command -v volta &>/dev/null; then
  curl -fsSL https://get.volta.sh | bash
  export VOLTA_HOME="$HOME/.volta"
  export PATH="$VOLTA_HOME/bin:$PATH"
fi
volta install node@lts
npm install -g pnpm typescript
