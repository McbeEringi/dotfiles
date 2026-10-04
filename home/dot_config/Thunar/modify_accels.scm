#!/bin/bash
tempfile="$(mktemp)"
trap 'rm -rf "${tempfile}"' EXIT
cat > "${tempfile}"

[[ $(grep -oP 'uca-action-open-terminal-here' "${tempfile}") ]]||cat << EOF >> "${tempfile}"
(gtk_accel_path "<Actions>/ThunarActions/uca-action-open-terminal-here" "F4")
EOF

[[ $(grep -oP 'uca-action-open-with-mpv' "${tempfile}") ]]||cat << EOF >> "${tempfile}"
(gtk_accel_path "<Actions>/ThunarActions/uca-action-open-with-mpv" "F6")
EOF

[[ $(grep -oP 'uca-action-paste-as-file' "${tempfile}") ]]||cat << EOF >> "${tempfile}"
(gtk_accel_path "<Actions>/ThunarActions/uca-action-paste-as-file" "F7")
EOF

cat "${tempfile}"
