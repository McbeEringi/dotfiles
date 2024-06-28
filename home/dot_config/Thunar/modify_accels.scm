#!/bin/bash
tempfile="$(mktemp)"
trap 'rm -rf "${tempfile}"' EXIT
cat > "${tempfile}"

[[ $(grep -oP 'uca-action-open-terminal-here' "${tempfile}") ]]||cat << EOF >> "${tempfile}"
(gtk_accel_path "<Actions>/ThunarActions/uca-action-open-terminal-here" "F4")
EOF

[[ $(grep -oP 'uca-action-open-code-here' "${tempfile}") ]]||cat << EOF >> "${tempfile}"
(gtk_accel_path "<Actions>/ThunarActions/uca-action-open-code-here" "<Shift>F4")
EOF

cat "${tempfile}"