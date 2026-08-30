#!/usr/bin/env bash
# deploy.sh - Deploy Kavita Themes
# Domain: kavita / free-warez.win
# Target Host: free-warez.win -> /opt/containers/kavita/data/themes/

set -euo pipefail

TARGET_HOST="free-warez.win"
LOCAL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEMES_DIR="$LOCAL_DIR/themes"
REMOTE_THEMES_DIR="/opt/containers/kavita/data/themes"

echo "🚀 Deploying Kavita Themes"
echo "   Target Host: $TARGET_HOST:$REMOTE_THEMES_DIR"
echo "========================================================="

# 1. Check SSH connection
echo "📡 Checking SSH connection to $TARGET_HOST..."
if ! ssh -q -o BatchMode=yes -o ConnectTimeout=5 "$TARGET_HOST" exit; then
    echo "❌ Cannot connect to $TARGET_HOST via SSH."
    exit 1
fi

# 2. Sync CSS files
echo "🔄 Transferring themes to $TARGET_HOST..."
rsync -avz "$THEMES_DIR/" "$TARGET_HOST:$REMOTE_THEMES_DIR/"

# 3. Restart Kavita to discover new themes
echo "🔄 Reloading Kavita container..."
ssh "$TARGET_HOST" "docker restart kavita"

echo "✅ Kavita theme(s) deployed successfully!"
echo "✨ Deployment complete!"
