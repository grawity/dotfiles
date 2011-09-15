#!/bin/bash
[ "$GPG_AGENT_INFO" ] &&
cat <<-'EOF'
set crypt_use_gpgme
EOF

exit 0
