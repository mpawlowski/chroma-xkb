remote_ids=$(xinput list | sed -n 's/.*Razer Razer Orbweaver Chroma.*id=\([0-9]*\).*keyboard.*/\1/p')

[ "$remote_ids" ] || exit

mkdir -p /tmp/xkb/symbols

cat >/tmp/xkb/symbols/custom <<\EOF
xkb_symbols "remote" {
    key <TLDE> {         [          Escape ] };
    key <CAPS> {         [         Shift_L ] };
};
EOF

for id in $remote_ids
do
    setxkbmap -device $id -print \
    | sed 's/\(xkb_symbols.*\)"/\1+custom(remote)"/' \
    | xkbcomp -I/tmp/xkb -i $id -synch - $DISPLAY
done

