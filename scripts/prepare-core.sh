#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
core_dir="$root_dir/externals/core"
patch_file="$root_dir/patches/zerotier-core-1.16.2.patch"

if git -C "$core_dir" apply --reverse --check "$patch_file" 2>/dev/null; then
    echo "ZeroTier Android patches already applied"
    exit 0
fi

git -C "$core_dir" apply --check "$patch_file"
git -C "$core_dir" apply "$patch_file"
echo "Applied ZeroTier Android patches"
